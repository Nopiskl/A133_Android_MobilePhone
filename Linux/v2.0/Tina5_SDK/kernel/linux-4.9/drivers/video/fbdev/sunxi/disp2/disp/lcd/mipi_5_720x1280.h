/* drivers/video/sunxi/disp2/disp/lcd/k101im2qa04.h
 *
 * Copyright (c) 2017 Allwinnertech Co., Ltd.
 * Author: zhengxiaobin <zhengxiaobin@allwinnertech.com>
 *
 * k101im2qa04 panel driver
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
*/

#ifndef _MIPI_5_720X1280_H
#define _MIPI_5_720X1280_H

#include "panels.h"

typedef struct __lcd_panel __lcd_panel_t;

extern struct __lcd_panel mipi_5_720x1280_panel;
extern s32 bsp_disp_get_panel_info(u32 screen_id, struct disp_panel_para *info);

#endif /*End of file*/
