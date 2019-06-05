*** Settings ***
Documentation           使用telnet库 进行spectral enable radio测试的案例，测试需要先配置AC、AP的IP、端口、名字、具体内容看Variables字段
Library	                Telnet	prompt=(>|#)$	prompt_is_regexp=yes									# set prompt as a regular expression（将prompt设置为正则表达式）
Library	                Telnet	terminal_emulation=True	    terminal_type=vt100	window_size=400x100
Library                 String
Suite Setup             Open Connection And Log In														#场景进入通过Open Connection And Log In	函数
Suite Teardown          Close All Connections

*** Variables ***
${AC_HOST}				172.30.103.194																	#AC ip，根据实际配置
${AC_PORT}				23																				#AC 端口，根据实际配置
${AP_HOST}				172.30.103.49
${AP_PORT}				23
${AP_MAC}				00d0.f822.334c 																	#AP mac 地址
${AP_NAME}				AP740-I-newFlash
${AP_PWD}              	ruijie
${AP_EN_PWD}           	apdebug

*** Test Cases ***
Test spectral enable radio 1 是否实际生效
	[Documentation]    测试配置是否生效.
	${output}=          Execute Command    show running-config | i spectral
	Should Match        ${output}          *spectral enable radio 1*
	Write				terminal monitor																#telnet 也能监视串口log
	Write				debug syslog limit numbers 0 time 0												#debug log 限制关闭
	Write				y																				#确认关闭
	Write				debug syslog limit reset														#系统log 复位开始打印扫描频谱信息
	Read Until Prompt
	Write				co
	Write				spectral
	Write				spectral debug level 24
	Read Until Prompt
	Sleep				20s
	Write Bare			\r\n																			#后面跟关键字 \r\n 都需要用Write Bare
	${output}=		Read Until Prompt	
	Should Match        ${output}          *freq(24*
	Should Not Match 	${output}          *freq(5*

Test spectral enable radio 2 是否实际生效
	Switch Connection	1
	Write Bare			\r\n	
	Read Until Prompt
	Write				no spectral enable radio 1
	Write				spectral enable radio 2
	Read Until Prompt
	Switch Connection	2
	${output}=          Execute Command    show running-config | i spectral
	Should Match        ${output}          *spectral enable radio 2*
	Write Bare			\r\n
	Read Until Prompt
	Sleep				20s
	Write Bare			\r\n																			#生成收搜提示字符串(>|#)
	${output}=		Read Until Prompt	
	Should Match		${output}          *freq(5*
	Should NOT Match	${output}          *freq(24*

Test spectral enable radio 3 是否实际生效
	Switch Connection	1
	Write Bare			\r\n	
	Read Until Prompt
	Write				no spectral enable radio 2
	Write				spectral enable radio 3
	Read Until Prompt
	Switch Connection	2
	${output}=          Execute Command    show running-config | i spectral
	Should Match        ${output}          *spectral enable radio 3*
	Write Bare			\r\n
	Read Until Prompt
	Sleep				20s
	Write Bare			\r\n																			#生成收搜提示字符串(>|#)
	${output}=		Read Until Prompt	
	Should Match		${output}          *freq(5*
	Should NOT Match	${output}          *freq(24*
	
Test spectral enable radio x 结束
	log to console	test end
	Switch Connection	1
	Write Bare			\r\n	
	Read Until Prompt
	Write				no spectral enable radio 3														#关闭配置
	${output}=          Execute Command    show ap-config running ${AP_NAME}							#执行命令，将获取的序列号保存在${output}中;
	Should NOT Match	${output}          *spectral enable radio*

*** Keywords ***

Open Connection And Log In
	#*************AC 配置spectral enable radio 1 ******#
	Open Connection      ${AC_HOST}      port=${AC_PORT}
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
	Write				spectral enable radio 1
	Read Until Prompt
	
	Open Connection      ${AP_HOST}      port=${AP_PORT}
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