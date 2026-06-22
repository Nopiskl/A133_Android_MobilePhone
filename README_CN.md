# Nopiskl-a133 TinaLinux SDK

**语言：** [English](README.md) | 中文

这是一个围绕 Allwinner A133 平台整理的软硬件适配仓库，目标是为 `nopiskl-a133` 板卡提供可复用的 Linux、Ubuntu TinaLinux 与 Android 适配资料。

当前项目主要面向智能麦克风、便携终端、广告牌、MP4/类手机形态设备等场景。仓库中包含板级配置、设备树、内核配置、文件系统适配资料、硬件资料和部分参考镜像。

## 硬件与系统预览

<p align="center">
  <table>
    <tr>
      <td align="center">
        <img src="A133_Hardware/Hardware/v1.0/QQ20260619-130514.png" width="300" alt="Mini-PAD A133 hardware v1.0" />
        <br />
        <sub>Mini-PAD 硬件 v1.0 渲染图</sub>
      </td>
      <td align="center">
        <img src="A133_Hardware/Hardware/v2.0/1.png" width="240" alt="Nopiskl A133 hardware v2.0 reference" />
        <br />
        <sub>硬件 v2.0 参考排版图</sub>
      </td>
      <td align="center">
        <img src="A133_Hardware/TestImage/1.png" width="220" alt="A133 Android 10 test image" />
        <br />
        <sub>Android 10 测试画面</sub>
      </td>
    </tr>
  </table>
</p>

## 项目状态

目前已整理和验证的方向包括：

| 方向 | 状态 | 适用场景 |
| --- | --- | --- |
| TinaLinux | 可作为主线量产配置继续开发 | 嵌入式产品、Qt 应用、硬件编解码、GPU 加速、OTA 与开机自检 |
| TinaLinux Ubuntu | 可用于 Ubuntu base rootfs 开发 | 最小智能广告牌、随身终端、通用 Linux 应用验证 |
| Android 10/13 | 已基于 KICKPI 与 100ASK 方案做适配整理 | Android MP4、类手机设备、词典笔等 Android 应用场景 |

摄像头相关 pipeline 仍在适配中。硬件编解码与 GPU 加速相关内容已做过整理，但不同 rootfs 和桌面环境下的表现不同，使用时请结合下方说明选择文件系统。

## 硬件资料版本

| 版本 | 目录 | 内容 |
| --- | --- | --- |
| v1.0 | `A133_Hardware/Hardware/v1.0` | Mini-PAD / A133 平板硬件资料 |
| v2.0 | `A133_Hardware/Hardware/v2.0` | A133 参考排版硬件资料 |

## 目录说明

```text
A133_Hardware/
  Hardware/                     硬件工程资料
    v1.0/                       Mini-PAD / A133 平板硬件资料
    v2.0/                       早期 A133 参考硬件资料
  TestImage/                    测试图片或参考输出
  Design_References/            Kickpi、原厂等参考资料
    Kickpi_Board_Drawings/      Kickpi 板型与图纸
    Vendor_References/          原厂参考资料

Android/
  READEME.md                    Android 适配说明

Linux/
  Custom_A133_Codec_Port/       Cedar/Codec 相关适配文件
  Custom_A133_Qt_GPU_Rootfs/    Qt + GPU 文件系统整理资料
  v1.0/                         当前硬件版本的 TinaLinux 适配资料
    Tina4_KICKPI_suitable/      Tina4/KICKPI 相关适配资料
    Tina4_SDK_Industrial_ROS/   Tina4 工业 ROS 方向适配资料
    Tina5_SDK/                  标准 Tina5 Linux SDK 适配资料
    Tina5_SDK-ubuntu/           Tina5 Ubuntu SDK 适配资料
  v2.0/                         迁移前旧版 TinaLinux 适配资料归档
    Tina4_KICKPI_suitable/
    Tina4_SDK_Industrial_ROS/
    Tina5_SDK/
    Tina5_SDK-ubuntu/
```

`Linux/v1.0` 基于 A133 `c3` 板级配置重新整理，只保留板级 DTS/FEX、分区/环境配置、启动资源、必要 bin、WiFi 固件和 SDK 构建入口等重点文件。当前 `board.dts` 使用 `default_lcd` RGB 1024x600 配置，因此 v1.0 不再放置旧版 `mipi_5_720x1280` 相关屏幕驱动片段。`Linux/v2.0` 保留迁移前的旧 TinaSDK 目录，方便回查历史差异。

## 系统方案选择

### 1. TinaLinux

TinaLinux 是当前更适合产品化开发的方案。它基于 Allwinner 完整 SDK 流程，适合做稳定的板级系统、动态 OTA、开机自检、硬件编解码和 GPU 加速。

推荐用途：

- Qt + GPU 应用开发
- 硬件编解码验证
- Camera pipeline 快速验证
- 需要 Allwinner 量产流程的嵌入式产品

### 2. TinaLinux Ubuntu

TinaLinux Ubuntu 更适合做通用 Linux 应用验证。它可以适配主流 Linux 软件，适合作为最小智能广告牌、随身终端或轻量桌面设备的基础系统。

注意事项：

- 硬件编解码和 GPU 相关适配资料已经整理。
- 目前不建议期待 XFCE/Wayland 桌面环境直接获得完整 GPU 加速体验。
- 如果重点是 GPU 或 Qt，建议使用 `QT+GPU` 方向的 rootfs，并关闭 XFCE 等桌面环境。
- 如果重点是桌面体验，可以使用 `xfce` 方向 rootfs。

### 3. Android 10/13

Android 方向基于 KICKPI Android10 与 100ASK Android 方案修改整理。整体更接近标准 Android 手机模型，但不包含基带与蜂窝网络适配。

推荐用途：

- Android MP4
- 随身智能终端
- 类手机设备
- 词典笔等 Android 应用形态

更多说明见：

```text
Android/READEME.md
```

## TinaLinux Ubuntu 构建流程

以下流程适用于：

```text
Linux/v1.0/Tina5_SDK-ubuntu
```

完整 SDK 编译流程可参考 KICKPI 文档：

```text
https://gitee.com/tanzhtanzh/kickpi-book/blob/master/a133/zh/
```

根据用途选择 rootfs：

- 如果需要 XFCE 桌面，使用文件名以 `(xfce)` 开头的 rootfs，也可以使用 KICKPI 提供的 rootfs。
- 如果需要 Qt + GPU，使用文件名以 `(QT+GPU)` 开头的 rootfs，并将 `overlay.tar` 解压到 SDK 的 `overlay` 目录。

将选定的 rootfs 放入：

```text
a133-linux/device/config/rootfs_tar/
```

并重命名为：

```text
rootfs_ubuntu_nopiskl_k5_1604lts.tar.gz
```

选择以下板级配置：

```text
BoardConfig-a133-nopiskl-a133.mk
```

## Tina4 SDK 开发说明

Tina4 SDK 可参考 100ASK 的 R818 DshanPI ROSx 开发环境说明：

```text
https://docs.100ask.net/dshanpi/docs/R818-DshanPI-ROSx/part3/DevelopmentEnvironmentSetup
```

基本流程：

1. 获取 Tina4 SDK 本体。
2. 按 100ASK 文档搭建编译环境。
3. 使用本仓库中的 `Linux/v1.0/Tina4_SDK_Industrial_ROS` 覆盖对应 SDK 文件。
4. 按 100ASK 流程选择配置并编译。

打包注意事项请参考：

```text
Linux/v1.0/Tina4_SDK_Industrial_ROS/READEME.md
```

## 标准 Tina5 SDK 开发说明

标准 Tina5 SDK 可参考 100ASK A133 mCore 文档：

```text
https://dshanpi.100ask.net/docs/A133-mCore/SourceCodeToolDocumentationManual/
```

本仓库对应适配目录为：

```text
Linux/v1.0/Tina5_SDK
```

## 使用建议

- 如果目标是产品化嵌入式 Linux，优先从 `Linux/v1.0/Tina5_SDK` 或 TinaLinux 方向开始。
- 如果目标是通用 Linux 软件验证，优先从 `Linux/v1.0/Tina5_SDK-ubuntu` 开始。
- 如果目标是 Android 应用生态，参考 `Android` 目录。
- 修改设备树或 defconfig 后，建议重新完整编译并烧录验证，尤其是电源、显示、触摸、WiFi/BT、音频和存储相关配置。

## 致谢与参考

本项目整理过程中参考了 Allwinner Tina SDK、KICKPI A133 资料和 100ASK DshanPI/A133 相关文档。相关链接已在对应章节列出。
