E:
cd \learn\robot\FSS_TEST\spectral_enable_radio
robot  -l log -r report spectral_enable_radio.robot
ping 127.0.0.1 -n 3 >nul

cd E:\learn\robot\FSS_TEST\spectral_debug_level_24
robot  -l log -r report spectral_debug_level_24.robot
ping 127.0.0.1 -n 3 >nul

cd E:\learn\robot\FSS_TEST\spectral_enable
robot  -l log -r report spectral_enable.robot
ping 127.0.0.1 -n 3 >nul

cd E:\learn\robot\FSS_TEST\spectral_offline_config
robot  -l log -r report spectral_offline_config.robot
ping 127.0.0.1 -n 3 >nul

cd E:\learn\robot\FSS_TEST\spectral_radio_up_down
robot  -l log -r report spectral_radio_up_down.robot
ping 127.0.0.1 -n 3 >nul

cd E:\learn\robot\FSS_TEST\spectral_enable_after_radio_down
robot  -l log -r report spectral_enable_after_radio_down.robot
ping 127.0.0.1 -n 3>nul

cd E:\learn\robot\FSS_TEST\spectral_radio_up_down_after_config
robot  -l log -r report spectral_radio_up_down_after_config.robot
ping 127.0.0.1 -n 3>nul

cd E:\learn\robot\FSS_TEST\spectral_device_mode_monitor_radio
robot  -l log -r report spectral_device_mode_monitor_radio.robot
ping 127.0.0.1 -n 3 >nul

cd E:\learn\robot\FSS_TEST\spectral_device_mode_monitor_radio_dual
robot  -l log -r report spectral_device_mode_monitor_radio_dual.robot
ping 127.0.0.1 -n 100000 >nul