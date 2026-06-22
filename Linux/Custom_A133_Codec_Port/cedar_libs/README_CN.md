# Notice

**语言：** [English](README.md) | 中文

如果发现 Ubuntu 下音频播放问题，需要使用 Tina ALSA 库 + 最简 `asound.conf`。

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
