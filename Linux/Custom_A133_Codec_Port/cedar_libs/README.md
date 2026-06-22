# Notice
如果发现ubuntu下音频播放问题，需要使用tina alsa库+最简asound.conf

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