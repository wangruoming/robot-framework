*** Settings ***
Library  Telnet  prompt=(>|#|:)$  prompt_is_regexp=yes
Library  SSHLibrary
Library  Collections
Library  String    

*** Test Cases ***
fss_auto_test：(no) spectral enable radio 1/2/3 and (no) spectral enable
	#****************参数配置，目前需要依据特定环境修改配置***********************#
	${AC_IP}			Set variable	172.30.103.194
	${AC_PORT}			Set variable	23
	${AC_TEST_CMD1}		Set variable	spectral enable radio 1
	${AC_TEST_CMD2}		Set variable	spectral enable radio 2
	${AC_TEST_CMD3}		Set variable	spectral enable radio 3
	${AC_TEST_CMD4}		Set variable	spectral enable
	${AC_CHECK_RET1}	Set variable	spectral enable radio 1
	${AC_CHECK_RET2}	Set variable	spectral enable radio 2
	${AC_CHECK_RET3}	Set variable	spectral enable radio 3
	${AC_CHECK_RET4}	Set variable	spectral enable
	${AC_CHECK_TMP}		Set variable	*00d0.f822.334c*							#AP_MAC，用于AC 上进行字符串比较
	
	${AP_IP}			Set variable	172.30.103.49
	${AP_PORT}			Set variable	23
	${AP_MAC}			Set variable	00d0.f822.334c
	${AP_NAME}			Set variable	AP740-I-newFlash
	${AP_CHECK_CMD}		Set variable	show running-config | i spectral
	${AP_CHECK_RET1}	Set variable	spectral enable radio 1
	${AP_CHECK_RET2}	Set variable	spectral enable radio 2
	${AP_CHECK_RET3}	Set variable	spectral enable radio 3
	${AP_CHECK_RET4}	Set variable	spectral enable
	
	${Password}			Catenate		ruijie										#拼接字符串
	${Password_op}		Catenate		en											#拼接字符串
	${Password1}		Set variable	apdebug										#设置字符串
	
	#************AC 配置spectral enable radio 1********#
	Telnet.Open Connection  host=${AC_IP}  port=${AC_PORT}						#telnet 到AC上
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s
	Telnet.Write Bare	co														#\r\n
	Telnet.Write Bare	\r\n	
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s
	Telnet.Write Bare	ap-config ${AP_MAC}
	Telnet.Write Bare	\r\n
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s ap							#查看AC 是否进入ap-config配置状态
	#************AC 初始化spectral 配置********#
	Telnet.Write 	no ${AC_TEST_CMD1}											#取消spectral enable radio 1配置
	Telnet.Write	no ${AC_TEST_CMD2}
	Telnet.Write	no ${AC_TEST_CMD3}
	Telnet.Write	no ${AC_TEST_CMD4}
	Sleep  1s
	
	Telnet.Write Bare	${AC_TEST_CMD1}
	Telnet.Write Bare	\r\n
	Telnet.Write	${AC_TEST_CMD2}
	Telnet.Write	${AC_TEST_CMD3}
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s spectral						#查看配置情况，通过spectral	查看
	Telnet.Write	show ap-config running ${AP_NAME}
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  ${AC_CHECK_RET1}
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  ${AC_CHECK_RET2}
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  ${AC_CHECK_RET3}
	Sleep  1s																	#要睡眠的时间
	#************AP检查AC 配置********#
	Telnet.Open Connection  host=${AP_IP}  port=${AP_PORT}						#telnet 到AP上
	log to console	${Password}													#向终端打印字符串
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  Username:  Password: 		#telnet 读取界面直到出现需要的字符串 Username： or Password：
	Telnet.Write Bare	${Password}												#输入密码
	Telnet.Write Bare	\r\n													#输入回车
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s								#telnet 读取界面直到出现需要的字符串：
	log to console	${Password_op}
	Telnet.Write Bare	${Password_op}
	Telnet.Write Bare	\r\n	
	log to console	${Password1}
	Telnet.Write Bare	${Password1}
	Telnet.Write Bare	\r\n	
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s
	Telnet.Write	${AP_CHECK_CMD}												#使用Telnet.Write 不用回车（\r\n）
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  ${AP_CHECK_RET1}				#AP检查配置，PASS 表示返回AP检查的结果通过
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  ${AP_CHECK_RET2}
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  ${AP_CHECK_RET3}
	Sleep  1s
	#************AC取消AP spectral enable radio x 配置********#
	Telnet.Switch Connection	1												#切换telent到第一个链接，注意Switch Connection中间是空格不是tab
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s
	Telnet.Write 	no ${AC_TEST_CMD1}
	Telnet.Write	no ${AC_TEST_CMD2}
	Telnet.Write	no ${AC_TEST_CMD3}
	Telnet.Write	show ap-config running ${AP_NAME}
	${output}	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s					#将读到的配置信息输入output
	log to console	${output}
	Should Not Match	${output}	*spectral enable*							#没有找到配置字符串表示成功 *用来修饰要匹配的字符串
	Should Match	${output}	${AC_CHECK_TMP}									#匹配到AP MAC 表示成功
	#************AP检查AC 取消的配置是否生效********#
	Telnet.Switch Connection	2
	Telnet.Write Bare	\r\n													#回车，生成新的命令行操作，等待输入命令
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s								#读输出，直到期望的规则(>|#)出现
	Telnet.Write	${AP_CHECK_CMD}	
	${output}	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s
	Should Not Match	${output}	*spectral enable*
	
	#************AC 配置AP spectral enable********#
	Telnet.Switch Connection	1
	Telnet.Write Bare	\r\n	
	Telnet.Write	${AC_TEST_CMD4}
	Telnet.Write	show ap-config running ${AP_NAME}
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  ${AC_CHECK_RET4}
	
	#************AP 检测AC spectral enable 配置********#
	Telnet.Switch Connection	2
	Telnet.Write Bare	\r\n
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s
	Telnet.Write	${AP_CHECK_CMD}
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  ${AP_CHECK_RET4}
	
	#************AC 取消配置AP spectral enable********#
	Telnet.Switch Connection	1
	Telnet.Write Bare	\r\n	
	Telnet.Write	no ${AC_TEST_CMD4}
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s
	Sleep  1s
	Telnet.Write	show ap-config running ${AP_NAME}
	${output}	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s
	Should Not Match	${output}	*spectral enable*
	#************AP 检测AC 取消spectral enable 配置********#
	Telnet.Switch Connection	2
	Telnet.Write Bare	\r\n	
	Telnet.Write	${AP_CHECK_CMD}
	${output}	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s
	Should Not Match	${output}	*spectral enable*
	
	[Teardown]  Telnet.Close All Connections									#断开所有telnet 链接
    #visit_via_telnet  ${dev.host}  ${dev.port}
    
