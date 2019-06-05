*** Settings ***
Library	                Telnet	prompt=(>|#)$	prompt_is_regexp=yes				#表示每次读取prompt从前一个提示字符处（>|#|:） 到下一个提示字符出
Library	                Telnet	terminal_emulation=True	    terminal_type=vt100	window_size=400x100
Library  				Collections
Library  				String    
Library					Selenium2Library	implicit_wait=5
Suite Setup             Open Connection And Login And Disconnet Capwap				#场景进入通过关键字链接、登录、断开capwap函数
Suite Teardown          Close All Connections

Variables	../variables/ap_config.py								#存放AP IP、PROT、MAC、NAME的地方
Variables	../variables/ac_config.py								#存放AC IP、PROT的地方

*** Variables ***
${AC_TEST_CMD1}		spectral enable radio 1											#全局变量直接赋值
${AC_TEST_CMD2}		spectral enable radio 2											#全局变量直接赋值
${AC_TEST_CMD3}		spectral enable radio 3											#全局变量直接赋值
${AP_PWD}              	ruijie
${AP_EN_PWD}           	apdebug

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
	Write				co
	Write				spectral
	Write				spectral debug level 24

*** Test Cases ***
Test AP radio 1 shutdown after config spectral enable radio 1 
	[Documentation]    先配置spectral enable radio 1，再关闭radio 1
	#****切换到AC配置spectral enable radio 1*********#
	Switch Connection	1
	Write Bare	\r\n
	Read
	Write				spectral enable radio 1
	${output}=          Execute Command    show ap-config running ${AP_NAME}
	Should Match		${output}          *${AC_TEST_CMD1}*
	Sleep				1s
	
	#****切换到AP查看spectral enable radio 1配置*********#
	Switch Connection	2
	#****在AP 上关闭radio 1*********#
	Write Bare			\r\n	
	Read
	Write				end
	Write				configure 
	Write				int dot11radio 1/0
	Write				shutdown
	Read
	${output}=          Execute Command    show running-config | i spectral
	Should Match		${output}          *${AC_TEST_CMD1}*
	
	#****切换到AC配置no spectral enable radio 1*********#
	Switch Connection	1
	Write Bare	\r\n
	Read
	Sleep				1s
	Read
	Write				no spectral enable radio 1
	${output}=          Execute Command    show ap-config running ${AP_NAME}
	Should Not Match		${output}          *${AC_TEST_CMD1}*
	Sleep				1s
	
	#****切换到AP确认no spectral enable radio 1，且实际已经生效*********#
	Switch Connection	2
	#****在AP 上关闭radio 1*********#
	Write Bare			\r\n	
	Read
	Write				configure
	Write				int dot11radio 1/0
	Write				no shutdown
	Read
	Sleep				1s
	Read
	${output}=          Execute Command    show running-config | i spectral
	Should Not Match		${output}          *${AC_TEST_CMD1}*
	Sleep				10s
	${output}=          Read
	Should Not Match		${output}          *freq(24*
	
*** Test Cases ***
Test AP radio 2 shutdown after config spectral enable radio 2 
	[Documentation]    先配置spectral enable radio 2，再关闭radio 2
	#****切换到AC配置spectral enable radio 2*********#
	Switch Connection	1
	Write Bare	\r\n
	Read
	Write				spectral enable radio 2
	${output}=          Execute Command    show ap-config running ${AP_NAME}
	Should Match		${output}          *${AC_TEST_CMD2}*
	Sleep				1s
	
	#****切换到AP查看spectral enable radio 2配置*********#
	Switch Connection	2
	#****在AP 上关闭radio 1*********#
	Write Bare			\r\n	
	Read
	Write				end
	Write				configure 
	Write				int dot11radio 2/0
	Write				shutdown
	Read
	Sleep				1s
	Read
	${output}=          Execute Command    show running-config | i spectral
	Should Match		${output}          *${AC_TEST_CMD2}*
	
	#****切换到AC配置no spectral enable radio 2*********#
	Switch Connection	1
	Write Bare	\r\n
	Read
	Write				no spectral enable radio 2
	${output}=          Execute Command    show ap-config running ${AP_NAME}
	Should Not Match		${output}          *${AC_TEST_CMD2}*
	Sleep				1s
	
	#****切换到AP确认no spectral enable radio 2，且实际已经生效*********#
	Switch Connection	2
	#****在AP 上关闭radio 1*********#
	Write Bare			\r\n	
	Read
	Write				configure
	Write				int dot11radio 2/0
	Write				no shutdown
	Read
	Sleep				1s
	Read
	${output}=          Execute Command    show running-config | i spectral
	Should Not Match		${output}          *${AC_TEST_CMD2}*
	Sleep				10s
	${output}=          Read
	Should Not Match		${output}          *freq(5*
	
*** Test Cases ***
Test AP radio 3 shutdown after config spectral enable radio 3 
	[Documentation]    先配置spectral enable radio 3，再关闭radio 3
	#****切换到AC配置spectral enable radio 3*********#
	Switch Connection	1
	Write Bare	\r\n
	Read
	Write				spectral enable radio 3
	${output}=          Execute Command    show ap-config running ${AP_NAME}
	Should Match		${output}          *${AC_TEST_CMD3}*
	Sleep				1s
	
	#****切换到AP查看spectral enable radio 2配置*********#
	Switch Connection	2
	#****在AP 上关闭radio 1*********#
	Write Bare			\r\n	
	Read
	Write				end
	Write				configure 
	Write				int dot11radio 3/0
	Write				shutdown
	Read
	Sleep				1s
	Read
	${output}=          Execute Command    show running-config | i spectral
	Should Match		${output}          *${AC_TEST_CMD3}*
	
	#****切换到AC配置no spectral enable radio 3*********#
	Switch Connection	1
	Write Bare	\r\n
	Read
	Write				no spectral enable radio 3
	${output}=          Execute Command    show ap-config running ${AP_NAME}
	Should Not Match		${output}          *${AC_TEST_CMD3}*
	Sleep				1s

	#****切换到AP确认no spectral enable radio 3，且实际已经生效*********#
	Switch Connection	2
	#****在AP 上关闭radio 1*********#
	Write Bare			\r\n	
	Read
	Write				configure
	Write				int dot11radio 3/0
	Write				no shutdown
	Read
	Sleep				1s
	Read
	${output}=          Execute Command    show running-config | i spectral
	Should Not Match		${output}          *${AC_TEST_CMD3}*
	Sleep				10s
	${output}=          Read
	Should Not Match		${output}          *freq(5*

*** Test Cases ***
Test end and reset configure
	Switch Connection	1
	Write Bare	\r\n
	Read Until Prompt
	Write				no spectral enable radio 1
	Write				no spectral enable radio 2
	Write				no spectral enable radio 3
	Write				no spectral enable
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
Open Connection And Login And Disconnet Capwap
	#*************AC 配置spectral enable radio 1 ******#
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
	