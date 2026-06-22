# Linux v1.0 TinaLinux Adaptation

**Language:** English | [中文](README_CN.md)

This directory contains TinaLinux adaptation files for the current v1.0 hardware. The configuration is based on the A133 `c3` board configuration and, following the existing repository style, keeps only the key files.

## Directories

```text
Tina4_KICKPI_suitable/       Tina4/KICKPI adaptation snippets
Tina4_SDK_Industrial_ROS/    Tina4 Industrial ROS SDK adaptation snippets
Tina5_SDK/                   Standard Tina5 SDK adaptation snippets
Tina5_SDK-ubuntu/            Tina5 Ubuntu SDK adaptation snippets
```

## Scope

- Kept: `board.dts`, `sys_config.fex`, `arisc.config`, partition/environment configuration, boot-resource files, required boot binaries, WiFi firmware, and SDK defconfig/build helpers.
- Not kept: patch files directly migrated from `tmp`, generated `.dtbo` files, redundant historical configuration, and nested `.git` leftovers.
- Display: the current A133 `c3` configuration uses `default_lcd` RGB 1024x600. The old `mipi_5_720x1280` panel driver is not used, so v1.0 does not include the related driver files.

The older TinaLinux materials have been migrated to `Linux/v2.0`. Shared Codec and Qt/GPU rootfs materials remain under the `Linux/` root directory.
