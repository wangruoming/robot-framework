*** Settings ***
Documentation           使用telnet库 进行spectral enable radio测试的案例，测试需要先配置AC、AP的IP、端口、名字、具体内容看Variables字段
Library	                Telnet	prompt=(>|#)$	prompt_is_regexp=yes									# set prompt as a regular expression（将prompt设置为正则表达式）
Library	                Telnet	terminal_emulation=True	    terminal_type=vt100	window_size=400x100
Library                 String
Library  				../library/string_compare.py
Suite Setup             Open Connection And Login				#场景进入通过关键字链接、登录、断开capwap函数
Suite Teardown          Close All Connections

Variables	../variables/ap_config.py																	#存放AP IP、PROT、MAC、NAME的地方
Variables	../variables/ac_config.py																	#存放AC IP、PROT的地方

*** Variables ***
${AC_TEST_CMD1}		spectral enable radio 1											#全局变量直接赋值
${AC_TEST_CMD2}		spectral enable radio 2											#全局变量直接赋值
${AC_TEST_CMD3}		spectral enable radio 3											#全局变量直接赋值
${AP_PWD}              	ruijie
${AP_EN_PWD}           	apdebug

*** Test Cases ***
Test AP radio 1 shutdown after config spectral enable radio 1 
	[Documentation]    先配置spectral enable radio 1，再关闭radio 1
	#****切换到AC配置spectral enable radio 1*********#
	Switch Connection	1
	Write Bare	\r\n
	Read
	#Write				device mode monitor radio 1														#此项测试不开monitor
	Write				spectral enable radio 1
	${output}=          Execute Command    show ap-config running ${AP_NAME}
	Should Match		${output}          *${AC_TEST_CMD1}*
	#Should Match		${output}          *device mode monitor radio 1*
	Sleep				1s

	#****切换到AP查看spectral enable radio 1配置是否生效*********#
	Switch Connection	2
	${output}=          Execute Command				no spectral debug level
	Sleep	5s
	${output}=          Execute Command    show running-config | i spectral								#直接读取，不要在前面加一个Write Bare	\r\n
	Should Match		${output}          *${AC_TEST_CMD1}*

*** Test Cases ***
Test AP spectral debug level 24
	[Documentation]    打开debug
	Write Bare	\r\n
	Write				end
	Write				terminal monitor																#telnet 也能监视串口log
	Write				debug syslog limit numbers 0 time 0												#debug log 限制关闭
	Write				y																				#确认关闭
	Write				debug syslog limit reset														#系统log 复位开始打印扫描频谱信息
	Read
	Write				show version detail
	${output}=          Read
	${ret}=	fss_detected_interference	${output}	AP740-I (				#返回值是探测到的个数
	Run Keyword If	${ret}>=1	Switch Connection	1
	...	ELSE	log	${ret}
	Run Keyword If	${ret}>=1	Write	spectral stability bth 3
	...	ELSE	Write				log	${ret}
	Run Keyword If	${ret}>=1	Write	spectral stability mwo 4
	...	ELSE	Write				log	${ret}
	Run Keyword If	${ret}>=1	Switch Connection	2
	...	ELSE	Write				log	${ret}
	Write				co
	Write				spectral
	Write				spectral debug level 24
	
*** Test Cases ***
Test Detected bluetooth and microwave 
	[Documentation]    循环探测，总共探测1小时
	${Detected_cnt}    Set variable    0
	log		${Detected_cnt}
	#${Detected_cnt}		Evaluate	${Detected_cnt} + 2		#加法运算，变量+tab+关键字+执行语句
	#log		${Detected_cnt}
	: FOR    ${INDEX}    IN RANGE    0    60					#拷机一个小时
	\	Write Bare	\r\n
	\	Sleep	60s
	\	Log    ${INDEX}											#for 循环链接的关键字是\，\ 有多行就表示for的运行实体是哪些
	\	${output}=          Read
	\	Should Match		${output}          *freq(241*
	\	Should Match		${output}          *freq(243*
	\	Should Match		${output}          *freq(244*
	\	${ret}=	fss_detected_interference	${output}	Detected				#返回值是探测到的个数
	\	${Detected_cnt}		Evaluate	${Detected_cnt} + ${ret}
	\	log to console	\n Detected_cnt=${Detected_cnt}
	\	Run Keyword If		${Detected_cnt}<=5	log	${Detected_cnt}				#数字对比，${Detected_cnt}小于5，输出${Detected_cnt}，注意：log后面是tab#
	\	...	ELSE	Should Match		${output}          *Detected_cnt(${Detected_cnt}) > 5*

*** Test Cases ***
Test end and reset configure
	Switch Connection	1
	Write Bare	\r\n
	Read Until Prompt
	Write				spectral stability bth 1
	Write				spectral stability mwo 1
	Write				no spectral enable radio 1
	Write				no spectral enable radio 2
	Write				no spectral enable radio 3
	Write				no spectral enable
	Write				no device mode
	Read Until Prompt
	${output}=          Execute Command    show ap-config running ${AP_NAME}
	Should NOT Match	${output}          *spectral enable*
	
	Switch Connection	2
	Write Bare	\r\n
	Write		end
	Read
	${output}=          Execute Command				configure
	${output}=          Execute Command				spectral
	${output}=          Execute Command				no spectral debug level
	${output}=          Execute Command		end
	${output}=          Execute Command				configure 
	${output}=          Execute Command				int dot11radio 1/0
	${output}=          Execute Command				no shutdown
	${output}=          Execute Command		end
	${output}=          Execute Command				configure 
	${output}=          Execute Command				int dot11radio 2/0
	${output}=          Execute Command				no shutdown
	${output}=          Execute Command		end
	${output}=          Execute Command				configure 
	${output}=          Execute Command				int dot11radio 3/0
	${output}=          Execute Command				no shutdown

*** Keywords ***
Open Connection And Login
	#*************登录AC 初始化FSS 自动化测试环境 ******#
	Open Connection      ${AC_IP}      port=${AC_PORT}
	${CTRL_C}            Evaluate      chr(int(3))
	Set Timeout          1s
	Sleep				 1s
	Write Bare		    ${CTRL_C}
	Read Until Prompt
	Write				co
	Write				ap-config ${AP_MAC}
	Write				no spectral enable radio 1
	Write				no spectral enable radio 2
	Write				no spectral enable radio 3
	Write				no spectral enable
	Read Until Prompt
	${output}=          Execute Command    show ap-config running ${AP_NAME}
	Should NOT Match	${output}          *spectral enable*

	#*************登录AP 初始化FSS 自动化测试环境 ******#
	Open Connection      ${AP_IP}      port=${AP_PORT}
	${CTRL_C}            Evaluate      chr(int(3))
	Set Timeout          1s
	Sleep			    1s
	Write Bare		    ${CTRL_C}
	Read Until           Password:																			#read 到 Password:字符串
	Write                ${AP_PWD}
	Read Until Prompt
	Write                enable
	Read Until           Password:
	Write                ${AP_EN_PWD}
	Read Until Prompt																						#read 到 # 进入配置选项跳转到Test Cases 去执行