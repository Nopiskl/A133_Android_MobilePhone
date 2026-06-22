# Notice

**Language:** English | [中文](README_CN.md)

If audio playback issues appear under Ubuntu, use the Tina ALSA library together with a minimal `asound.conf`.

```conf
ctl.!default {
    type hw
    card 0
}

pcm.!default {
    type hw
    card 0
    device 0
}
```
