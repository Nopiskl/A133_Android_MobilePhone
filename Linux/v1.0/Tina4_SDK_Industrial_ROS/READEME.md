# Notice

**Language:** English | [中文](READEME_CN.md)

When using the R818 Tina4 SDK, the PMIC and SCP coprocessor firmware differ from the A133 hardware used in this project.

FES/BOOT0 performs PMIC detection. If the board uses the A133 PMIC, `AXP707`, the R818-generated BOOT0 cannot continue loading. Using the R818 BOOT0 output directly will stop at the following log:

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

Solution: run the normal build flow first. After the build finishes, a series of binaries will appear in the `bin` directory. Replace those binaries with the patched binaries, then run `pack` directly.
