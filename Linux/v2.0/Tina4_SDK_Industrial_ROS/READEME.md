# Notice

原因：使用R818 tina4 sdk时，由于芯片配套使用的的PMIC不同，配套SCP协处理器固件也不同，
因此在FES/BOOT0会有PMIC检测，如果是A133的PMIC(AXP707)就无法继续加载
直接使用编译出来的R818相关boot0无法启动，会卡在

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

解决方法：先执行正常编译流程，编译完成后会在bin目录看到一系列bin，然后拿补丁中的bin替换后，直接pack即可