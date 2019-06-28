用例描述（测试测试步骤，测试输入的描述）：
1. 配置2.4G/任意频宽
2. spectral enable radio 1
3. spectral debug level 24
4. spectral debug level 29

预期结果
radio_id = 1
freq = 2442(固定)
ch_width = 82(固定)
spectral_rssi = 0到255
bin_pwr_count = 213(固定)