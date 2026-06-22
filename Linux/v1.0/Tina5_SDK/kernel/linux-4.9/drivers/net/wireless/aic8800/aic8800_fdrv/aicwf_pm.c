#include <linux/version.h>
#include <linux/module.h>
#include <linux/err.h>
#include <linux/clk.h>
#include <linux/delay.h>
#include <linux/interrupt.h>
#include <linux/gpio.h>
#include <linux/ioport.h>
#include <linux/regulator/consumer.h>
#include <linux/sunxi-gpio.h>
#include <linux/gpio.h>
#include <linux/types.h>
#include <linux/pm_wakeirq.h>
#include <linux/spinlock.h>


#include "aicwf_txrxif.h"
#include <linux/mmc/host.h>
#include <linux/mmc/sdio.h>
#include <linux/mmc/sdio_ids.h>
#include <linux/mmc/sdio_func.h>
#include "aicwf_sdio.h"

extern void sunxi_wlan_set_power(bool on);
extern int sunxi_wlan_get_bus_index(void);
extern int sunxi_wlan_get_oob_irq(int *, int *);

static int wlan_bus_id;
static u32 gpio_irq_handle;
static int irq_flags, wakeup_enable;

int aicwf_get_syscfg(void)
{
	int wlan_bus_index = 0;
	wlan_bus_index = sunxi_wlan_get_bus_index();
	if (wlan_bus_index < 0)
		return wlan_bus_index;
	else
		wlan_bus_id = wlan_bus_index;
	gpio_irq_handle = sunxi_wlan_get_oob_irq(&irq_flags, &wakeup_enable);
	return wlan_bus_index;
}

#if 0
int xradio_wlan_power(int on)
{
	int ret = 0;
	if (on) {
	    ret = xradio_get_syscfg();
		if (ret < 0)
			return ret;
	}
	sunxi_wlan_set_power(on);
	mdelay(100);
	return ret;
}

void xradio_sdio_detect(int enable)
{
	MCI_RESCAN_CARD(wlan_bus_id);
	xradio_dbg(XRADIO_DBG_ALWY, "%s SDIO card %d\n",
				enable?"Detect":"Remove", wlan_bus_id);
	mdelay(10);
}
#endif

static irqreturn_t aicwf_gpio_irq_handler(int irq, void *bus_priv)
{
	struct aicwf_bus *bus_if = (struct aicwf_bus *)bus_priv;
	unsigned long flags;

	BUG_ON(!bus_if);
	//spin_lock_irqsave(&bus_if->bus_priv.sdio->lock, flags);
	if (bus_if->irq_handler)
		bus_if->irq_handler(bus_if->irq_priv);
    //spin_unlock_irqrestore(&bus_if->bus_priv.sdio->lock, flags);

	return IRQ_HANDLED;
}

int aicwf_request_gpio_irq(struct device *dev, void *bus_if)
{
	int ret = -1;

	ret = devm_request_irq(dev, gpio_irq_handle,
					(irq_handler_t)aicwf_gpio_irq_handler,
					irq_flags, "aicwf_irq", (void *)bus_if);
	if (ret < 0) {
		gpio_irq_handle = 0;
		printk("%s: request_irq FAIL!ret=%d\n", __func__, ret);
	}

	if (wakeup_enable) {
		ret = device_init_wakeup(dev, true);
		if (ret < 0) {
			printk("device init wakeup failed!\n");
			return ret;
		}

		ret = dev_pm_set_wake_irq(dev, gpio_irq_handle);
		if (ret < 0) {
			printk("can't enable wakeup src!\n");
			return ret;
		}
	}

	return ret;
}

static void aicwf_free_gpio_irq(struct device *dev, void *sbus_priv)
{
	struct sbus_priv *self = (struct sbus_priv *)sbus_priv;
	if (wakeup_enable) {
		device_init_wakeup(dev, false);
		dev_pm_clear_wake_irq(dev);
	}
	devm_free_irq(dev, gpio_irq_handle, self);
	gpio_irq_handle = 0;
}

int aicwf_sdio_irq_subscribe(struct aicwf_bus *bus_if, //self
				     sbus_irq_handler handler,
				     struct rwnx_hw *rwnx_hw) //void *priv)
{
	int ret = 0;
	unsigned long flags;

	if (!handler)
		return -EINVAL;

	printk("%s\n", __func__);

	//spin_lock_irqsave(&self->lock, flags);
	bus_if->irq_priv = rwnx_hw;
	bus_if->irq_handler = handler;
	//spin_unlock_irqrestore(&self->lock, flags);

	//sdio_claim_host(self->func);
	ret = aicwf_request_gpio_irq(&bus_if->bus_priv.sdio->func->dev, (void *)bus_if); //(&(self->func->dev), self);
	if (!ret) {
		printk("aicwf_sdio_irq_subscribe succ\n");
	} else {
		printk("aicwf_sdio_irq_subscribe failed(%d).\n", ret);
	}

	//sdio_release_host(self->func);

	return ret;
}




