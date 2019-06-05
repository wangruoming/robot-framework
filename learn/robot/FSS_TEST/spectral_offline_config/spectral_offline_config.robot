*** Settings ***
Library	                Telnet	prompt=(>|#)$	prompt_is_regexp=yes				#表示每次读取prompt从前一个提示字符处（>|#|:） 到下一个提示字符出
Library	                Telnet	terminal_emulation=True	    terminal_type=vt100	window_size=400x100
Library  				Collections
Library  				String    
Library					Selenium2Library	implicit_wait=5
Suite Setup             Open Connection And Login And Disconnet Capwap				#场景进入通过关键字链接、登录、断开capwap函数
Suite Teardown          Close All Connections

Variables	../variables/ap_config.py												#存放AP IP、PROT、MAC、NAME的地方
Variables	../variables/ac_config.py												#存放AC IP、PROT的地方

*** Variables ***
${AC_TEST_CMD1}		spectral enable radio 1											#全局变量直接赋值
${AC_TEST_CMD2}		spectral enable radio 2											#全局变量直接赋值
${AP_PWD}              	ruijie
${AP_EN_PWD}           	apdebug

*** Test Cases ***
Test offline ap config AP离线以后AC上是否可以配置
	[Documentation]    AP离线以后在AC上对AP进行配置，测试配置是否生效.
	Switch Connection	1
	Write Bare			\r\n	
	Read Until Prompt
	Write				${AC_TEST_CMD1}
	Write				${AC_TEST_CMD2}
	Write				spectral enable radio 20
	Read Until Prompt
	${output}=          Execute Command    show ap-config running ${AP_NAME}
	Should Match		${output}          *spectral enable radio 1*
	Should Match		${output}          *spectral enable radio 2*
	Should Match		${output}          *spectral enable radio 20*
	
	#*切换到AP，等待AP 和 AC 建立 capwap 隧道*#
	#Run Keyword And Ignore Error	
	Check AP CAPWAP		${AC_IP}													#这个关键字会将telnet切换到AP
	#**AP 重新建立capwap隧道以后，检测AC 在AP离线时候的配置 **#
	${output}=          Execute Command    show running-config | i spectral
	Should Match		${output}          *spectral enable radio 1*				#配置spectral enable radio 1要能够找到，AC 之前有配置
	Should Match		${output}          *spectral enable radio 2*				#配置spectral enable radio 2要能够找到，AC 之前有配置
	Should Not Match	${output}          *spectral enable radio 20*				#配置spectral enable radio 20不能够找到，AC 之前虽然有配置，但是AP不支持，待AP上线后，AC 相关的这条配置也要清除
	
	Switch Connection	1															#telnet切换回AC
	Write Bare			\r\n
	Read Until Prompt
	${output}=			Execute Command		show ap-config running ${AP_NAME}
	Should Match		${output}	*spectral enable radio 1*
	Should Match		${output}	*spectral enable radio 2*
	Should Not Match	${output}	*spectral enable radio 20*
	
	#*恢复配置*#
	Write				no spectral enable radio 1
	Write				no spectral enable radio 2
	Read Until Prompt
	${output}=          Execute Command    show ap-config running ${AP_NAME}
	Should NOT Match	${output}          *spectral enable*

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
	log to console		${AP_IP} 
	log to console		${CTRL_C}  
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
	#*****capwap断开，让AP 从AC 离线******#
	Write                co
	Read Until Prompt
	Write                test-capwap p d 1 0
	Sleep			    3s
	
Check AP CAPWAP
	#*************AP 检查是否和对应AC 建立capwap链接 ******#	
	[Arguments]    ${AC_IP_VALUE}
	Switch Connection	2																					#这段逻辑需要改进，应该是等待AP capwap 上对应AC 以后返回，
	: FOR    ${INDEX}    IN RANGE    1    20																#目前这段是for 循环，每次1s，每次获取ap上的capwap状态，没做条件满足后的
	\	log	${INDEX}																						#后的退出for循环，参考使用Run keyword if	${INDEX}==1	Exit For Loop
	\	Write Bare	\r\n
	\	Read Until Prompt
	\	${output}=          Execute Command    show capwap stat
	#\	Wait Until Element Contains	Should Match	${output}          *${AC_IP_VALUE}*
	\	Sleep	1s
	Should Match	${output}          *${AC_IP_VALUE}*													
	#Wait Until Element Contains