# Linux v1.0 TinaLinux Adaptation

本目录用于当前 v1.0 硬件的 TinaLinux 适配。配置来源以 A133 `c3` 板级配置为基准，并按仓库既有风格只保留关键文件。

## 目录

```text
Tina4_KICKPI_suitable/       Tina4/KICKPI 适配片段
Tina4_SDK_Industrial_ROS/    Tina4 工业 ROS SDK 适配片段
Tina5_SDK/                   标准 Tina5 SDK 适配片段
Tina5_SDK-ubuntu/            Tina5 Ubuntu SDK 适配片段
```

## 取舍

- 保留：`board.dts`、`sys_config.fex`、`arisc.config`、分区/环境配置、boot-resource、必要启动 bin、WiFi 固件、SDK defconfig/build helper。
- 不保留：`tmp` 中直接迁移过来的补丁文件、生成的 `.dtbo`、多余历史配置和嵌套 `.git` 残留。
- 屏幕：当前 A133 `c3` 配置使用 `default_lcd` RGB 1024x600，未使用旧版 `mipi_5_720x1280` panel 驱动，因此 v1.0 不放置对应驱动文件。

旧版 TinaLinux 资料已整体迁移到 `Linux/v2.0`，公共 Codec 和 Qt/GPU rootfs 资料继续保留在 `Linux/` 根目录。
