# Android Notice

**Language:** English | [中文](READEME_CN.md)

This directory records A133 Android adaptation notes.

The current Android adaptation mainly references the KICKPI Android 10 build flow and the 100ASK Android build and modification flow. This project applies its own A133 board adaptation on top of those references.

## Build References

- Android 10: refer to the KICKPI build flow.
- Android 13: refer to the 100ASK build flow.

## Build Environment

Pre-adapted Android build environment virtual machines are provided through Baidu Netdisk.

### Android 10

- File name: `android10.0`
- Link: <https://pan.baidu.com/s/1nPAfX07CXTr0sX0N1SWxhQ>
- Extraction code: `k4zw`

### Android 13

- File name: `A133_Android.7z`
- Link: <https://pan.baidu.com/s/1RGChdQvxaBzfzpMb143UUA>
- Extraction code: `csm9`

## Usage Notes

It is recommended to use the virtual machine environments above for builds first. This avoids build failures caused by differences in host OS versions, dependency versions, or Java environments.

If you need to set up the environment manually, check the dependencies, toolchain, JDK version, disk space, and source path configuration against the original KICKPI and 100ASK documentation.

## Notes

The Netdisk resources are shared through Baidu Netdisk Super Member v5. If a link expires, use later repository updates or Release notes as the source of truth.
