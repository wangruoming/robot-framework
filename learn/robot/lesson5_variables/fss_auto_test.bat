E:
cd \learn\robot\lesson5_variables\spectral_enable_radio
robot  -l log -r report spectral_enable_radio.robot
ping 127.0.0.1 -n 3 >nul

cd E:\learn\robot\lesson5_variables\spectral_debug_level_24
robot  -l log -r report spectral_debug_level_24.robot
ping 127.0.0.1 -n 5 >nul