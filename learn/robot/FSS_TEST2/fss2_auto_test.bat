E:
cd \learn\robot\FSS_TEST2\spectral_case1_01_2.4g
robot  -l log -r report spectral_case1_01_2.4g.robot
ping 127.0.0.1 -n 3 >nul

cd \learn\robot\FSS_TEST2\spectral_case1_02_5g_low
robot  -l log -r report spectral_case1_02_5g_low.robot
ping 127.0.0.1 -n 3 >nul

cd \learn\robot\FSS_TEST2\spectral_case1_02_5g_high
robot  -l log -r report spectral_case1_02_5g_high.robot
ping 127.0.0.1 -n 3 >nul


ping 127.0.0.1 -n 100000 >nul