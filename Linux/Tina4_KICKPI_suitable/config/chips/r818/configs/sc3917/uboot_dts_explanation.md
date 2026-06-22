# sc3917 当前 U-Boot DTS 说明

## 1. 文档目的

本文说明 `r818-sc3917` 当前配置下，U-Boot 启动阶段实际使用的是哪一套 DTS/DTB，以及它和本目录中的 `board.dts`、`sys_config.fex` 分别是什么关系。

## 2. 先给结论

当前工作树里，U-Boot 的 control DT 不是直接使用本目录的 `board.dts`。

它的主线更接近下面这条：

```text
CONFIG_DEFAULT_DEVICE_TREE = "sun50iw10p1-common"
        ->
sun50iw10p1-soc-system.dts
        +
.board-uboot.dts
        ->
U-Boot 自己的 control DT
        ->
打包阶段再由 sys_config.bin 对 u-boot.fex 做一次 update_uboot 修补
```

对当前这份代码树来说，`.board-uboot.dts` 会回落到：

```text
lichee/brandy-2.0/u-boot-2018/arch/arm/dts/sun50iw10p1-common-board.dts
```

而不是本目录的：

```text
device/config/chips/r818/configs/sc3917/board.dts
```

## 3. 为什么这样判断

### 3.1 当前 U-Boot `.config` 指向 `sun50iw10p1-common`

当前源码树中的 U-Boot 配置文件：

```text
lichee/brandy-2.0/u-boot-2018/.config
```

其中可以看到：

```text
CONFIG_DEFAULT_DEVICE_TREE="sun50iw10p1-common"
CONFIG_OF_BOARD=y
# CONFIG_OF_SEPARATE is not set
```

这说明当前 U-Boot 使用的是自己的 control DT 模型，并且默认设备树配置名是 `sun50iw10p1-common`。

## 3.2 U-Boot DT 不是直接手写成一份固定板级 dts，而是构建时拼出来

U-Boot 的 `Makefile` 中，`dts/dt.dtb` 的生成逻辑是：

1. 先准备 `.board-uboot.dts`
2. 再构建 `$(CONFIG_DEFAULT_DEVICE_TREE).dtb`

相关规则是：

```make
ifeq (x$(BOARD_DTS_EXIST),xyes)
    cp $(DTS_PATH)/$(LICHEE_IC)-$(LICHEE_BOARD)-board.dts $(DTS_PATH)/.board-uboot.dts
else
    cp $(DTS_PATH)/$(CONFIG_SYS_CONFIG_NAME)-common-board.dts $(DTS_PATH)/.board-uboot.dts
endif
```

这说明 `.board-uboot.dts` 只有两种来源：

1. 板级专用 U-Boot DTS
2. 芯片公共 `common-board.dts`

### 3.3 当前树里没有 `sc3917` 对应的 U-Boot 专用 board dts

当前 `lichee/brandy-2.0/u-boot-2018/arch/arm/dts/` 下能看到的相关文件主要是：

```text
a133-b1-board.dts
a133-b3-board.dts
a133-b4-board.dts
a133-b6-board.dts
sun50iw10p1-common-board.dts
sun50iw10p1-soc-system.dts
```

没有看到 `sc3917` 对应的 U-Boot 专用 `*-board.dts`。

因此，对这套代码树来说，U-Boot 会回落到：

```text
sun50iw10p1-common-board.dts
```

作为 `.board-uboot.dts`。

### 3.4 SoC 基底 DTS 是 `sun50iw10p1-soc-system.dts`

`sun50iw10p1-soc-system.dts` 文件末尾直接：

```dts
#include ".board-uboot.dts"
```

所以它和 `.board-uboot.dts` 的关系是：

- `sun50iw10p1-soc-system.dts` 提供 SoC 级基础节点
- `.board-uboot.dts` 叠加板级/启动期参数

两者组合后，形成当前 U-Boot 使用的 control DT。

## 4. `sun50iw10p1-common-board.dts` 里放的是什么

这份文件里有很多明显偏 bootloader 语义的内容，例如：

- `/soc/platform/debug_mode`
- `/soc/target/boot_clock`
- `/soc/target/storage_type`
- `/soc/target/burn_key`
- `/soc/target/dragonboard_test`

这些字段会被 U-Boot 启动早期逻辑直接读取，属于 U-Boot 自己要消费的配置，不等同于 Linux 运行期设备描述。

## 5. 本目录 `board.dts` 和 U-Boot DTS 的关系

本目录的：

```text
device/config/chips/r818/configs/sc3917/board.dts
```

主要用于 kernel/pack 这条链路，不是当前 U-Boot control DT 的直接来源。

它的作用更接近：

```text
sc3917/board.dts
    ->
kernel build 使用
    ->
sunxi.dtb
    ->
sunxi.fex
    ->
boot_package 中的 dtb item
```

所以：

- 改本目录 `board.dts`，主要影响 kernel/pack 侧 DTB
- 不等价于直接改掉当前 U-Boot 自己的 control DTS

## 6. `sys_config.fex` 和 U-Boot DTS 的关系

本目录的：

```text
device/config/chips/r818/configs/sc3917/sys_config.fex
```

不会在源码层面直接替代 U-Boot 使用的 DTS 文件，但会在打包阶段参与修补最终 `u-boot.fex`。

`scripts/pack_img.sh` 中可以看到：

```sh
update_uboot -no_merge u-boot.fex sys_config.bin
```

这说明最终进入镜像的 U-Boot FDT，还会被 `sys_config.bin` 更新一次。

因此它的关系应理解为：

```text
U-Boot DTS 源文件
    ->
生成 U-Boot control DT
    ->
pack 阶段再由 sys_config.fex 转成的 sys_config.bin 做修补
```

## 7. 当前配置的准确理解方式

如果只问“当前配置下 U-Boot 用的是哪份 DTS”，更准确的说法不是单独某一个文件，而是：

```text
配置名：
    sun50iw10p1-common

基底 DTS：
    lichee/brandy-2.0/u-boot-2018/arch/arm/dts/sun50iw10p1-soc-system.dts

板级 overlay：
    lichee/brandy-2.0/u-boot-2018/arch/arm/dts/sun50iw10p1-common-board.dts

打包修补输入：
    device/config/chips/r818/configs/sc3917/sys_config.fex
```

## 8. 对后续修改的建议

如果你要改的是下面这些内容：

- `debug_mode`
- `boot_clock`
- `storage_type`
- `dragonboard_test`
- U-Boot 启动早期依赖的节点

优先看 U-Boot 侧这两份文件：

- `sun50iw10p1-soc-system.dts`
- `sun50iw10p1-common-board.dts`

如果你改的是 Linux 设备节点、驱动启用状态、内核运行期设备描述，则优先看本目录的：

- `board.dts`

如果你改的是打包期注入给 bootloader 的参数，则还要同时关注：

- `sys_config.fex`
