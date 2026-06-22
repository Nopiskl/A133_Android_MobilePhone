# Notice

**语言：** [English](READEME.md) | 中文

原因：使用 R818 Tina4 SDK 时，由于芯片配套使用的 PMIC 不同，配套 SCP 协处理器固件也不同，因此在 FES/BOOT0 会有 PMIC 检测。如果是 A133 的 PMIC（AXP707）就无法继续加载。

直接使用编译出来的 R818 相关 BOOT0 无法启动，会卡在：

```txt
[196]HELLO! BOOT0 is starting!
[199]BOOT0 commit : e1a64ba
[202]set pll start
[204]periph0 has been enabled
[207]set pll end
[209]PL gpio voltage : 3.3V
[212][pmu]: bus read error
[215]PMU: AXP803
[229]vaild para:1  select dram para0
[232]board init ok, set sys_vol to 940mv!
[257]DRAM BOOT DRIVE INFO: V0.69
[260]the chip id is 0x1400
[263]ic cant match axp, please check...
```

解决方法：先执行正常编译流程，编译完成后会在 `bin` 目录看到一系列 bin，然后拿补丁中的 bin 替换后，直接 `pack` 即可。
