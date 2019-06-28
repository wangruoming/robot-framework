*** Settings ***
Library	                Telnet	prompt=(>|#)$	prompt_is_regexp=yes				#表示每次读取prompt从前一个提示字符处（>|#|:） 到下一个提示字符出
Library	                Telnet	terminal_emulation=True	    terminal_type=vt100	window_size=400x100
Library  				Collections
Library  				String    
Library					Selenium2Library	implicit_wait=5
Library  				../library/string_compare.py
Suite Setup             Open Connection And Login And Disconnet Capwap				#场景进入通过关键字链接、登录、断开capwap函数
Suite Teardown          Close All Connections

Variables	../variables/ap_config.py												#存放AP IP、PROT、MAC、NAME的地方
Variables	../variables/ac_config.py												#存放AC IP、PROT的地方

*** Variables ***
${AC_TEST_CMD1}		spectral enable radio 1											#全局变量直接赋值
${AC_TEST_CMD2}		spectral enable radio 2											#全局变量直接赋值
${AC_TEST_CMD3}		spectral enable radio 3											#全局变量直接赋值
${AP_PWD}              	ruijie
${AP_EN_PWD}           	apdebug

${RADIO_EQ}           	radio_id =
${RADIO_EQ_1}           radio_id = 2

*** Test Cases ***
Test bandwidth config and fss config
	[Documentation]    配置频宽，使能radio2的频谱检测
	#****切换到AC配置spectral enable radio 2 并且配置5g 36信道频宽为40MHZ*********#
	Switch Connection	1
	Write Bare	\r\n
	Read
	Write				channel 36 radio 2
	Write				chan-width 40 radio 2
	Write				spectral enable radio 2
	${output}=          Execute Command    show ap-config running ${AP_NAME}
	Should Match		${output}          *${AC_TEST_CMD2}*
	Should Match		${output}          *chan-width 40 radio 2*
	Sleep				1s

	#****切换到AP查看spectral enable radio 2配置是否生效*********#
	Switch Connection	2
	${output}=          Execute Command    show running-config | i spectral								#直接读取，不要在前面加一个Write Bare	\r\n
	Should Match		${output}          *${AC_TEST_CMD2}*
	${output}=          Execute Command    show dot11 wireless 2/0 | i Channel width                    #直接读取radio 1的频宽信息
	Should Match		${output}          *40Mhz*                                                      #radio 1 是否配置成了40MHZ
	
	#******打开log，查看频谱分析log***************#
	Write				terminal monitor																#telnet 也能监视串口log
	Write				debug syslog limit numbers 0 time 0												#debug log 限制关闭
	Write				y																				#确认关闭
	Write				debug syslog limit reset
	#Read Until Prompt
	Write				co
	Write				spectral
	Write				spectral debug level 24
	Write				spectral debug level 29
	Write Bare			\r\n
	Sleep				10s
	${output}=			Read
	Write				no spectral debug level
	Sleep				5s
	${output}=			Read
	#log to console	\n ${output}																		#打印log到终端
	
	#****比较output文件中的radio_id = 2、freq = 5250、ch_width = 160、spectral_rssi = 0、bin_pwr_count = 416*********#
	#radio_id = 1#
	${ret}=	fss_check_string	${output}	${RADIO_EQ}	${RADIO_EQ_1}									#调用python自写库，并传入${output}、'radio ='、'radio_id = 2' 三个字符串作为参数	
	Run Keyword If		${ret}==1	log	${ret}
	#...	ELSE	log	${ret}	Should Match	${output} *no find ${RADIO_EQ_1}*						#语法有问题，不能这样写，返回值不等于1，表示没有匹配对应数据，故失败提示
	...	ELSE	Should Match		${output}          *no find ${RADIO_EQ_1}*							#返回值不等于1，表示没有匹配对应数据，故失败提示
	
	#freq = 5250#
	${ret}=	fss_check_string	${output}	freq =	freq = 5250											#函数传参：字符串不用""或者'' 区别，直接写字符串就可以，用tab分割多个字符串
	Run Keyword If		${ret}==1	log	${ret}
	...	ELSE	Should Match		${output}          *no find freq = 5250*
	
	#ch_width = 160#
	${ret}=	fss_check_string	${output}	ch_width =	ch_width = 160
	Run Keyword If		${ret}==1	log	${ret}
	...	ELSE	Should Match		${output}          *no find ch_width = 160*
	
	#bin_pwr_count = 416#
	${ret}=	fss_check_string	${output}	bin_pwr_count =	bin_pwr_count = 416
	Run Keyword If		${ret}==1	log	${ret}
	...	ELSE	Should Match		${output}          *no find bin_pwr_count = 416*

	Sleep				5s
	
*** Test Cases ***
Test end and reset configure
	Switch Connection	1
	Write Bare	\r\n
	Read Until Prompt
	Write				no spectral enable radio 1
	Write				no spectral enable radio 2
	Write				no spectral enable radio 3
	Write				no spectral enable
	Write				no device mode
	Read Until Prompt
	${output}=          Execute Command    show ap-config running ${AP_NAME}
	Should NOT Match	${output}          *spectral enable*
	
	Switch Connection	2
	Write Bare			\r\n
	Read
	Write				no spectral debug level
	Write				end

*** Keywords ***
Open Connection And Login And Disconnet Capwap
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
	Sleep			     1s
	Write Bare		     ${CTRL_C}
	Read Until           Password:																			#read 到 Password:字符串
	Write                ${AP_PWD}
	Read Until Prompt
	Write                enable
	Read Until           Password:
	Write                ${AP_EN_PWD}
	Read Until Prompt								