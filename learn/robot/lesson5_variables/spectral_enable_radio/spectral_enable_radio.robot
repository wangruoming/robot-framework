*** Settings ***
Library  Telnet  prompt=(>|#|:)$  prompt_is_regexp=yes								#表示每次读取prompt从前一个提示字符处（>|#|:） 到下一个提示字符出
#Library  SSHLibrary																#不然Execute Command会有冲突，不知道是SSH 的还是telenet的
Library  Collections
Library  String    

Variables	../variables/ap_config.py												#存放AP IP、PROT、MAC、NAME的地方
Variables	../variables/ac_config.py												#存放AC IP、PROT的地方

*** Variables ***
${AC_TEST_CMD1}		spectral enable radio 1											#全局变量直接赋值
${AC_TEST_CMD2}		spectral enable radio 2
${AC_TEST_CMD3}		spectral enable radio 3
${AC_TEST_CMD4}		spectral enable
${AC_CHECK_RET1}	spectral enable radio 1
${AC_CHECK_RET2}	spectral enable radio 2
${AC_CHECK_RET3}	spectral enable radio 3
${AC_CHECK_RET4}	spectral enable
${AC_CHECK_TMP}		*${AP_MAC}*														#AP_MAC，用于AC 上进行字符串比较

#${AP_IP}			172.30.103.49													#变量存放在../variables/ap_config.py文件中
#${AP_PORT}			Set variable	23
#${AP_MAC}			00d0.f822.334c
#${AP_NAME}			AP740-I-newFlash
${AP_CHECK_CMD}		show running-config | i spectral
${AP_CHECK_RET1}	spectral enable radio 1
${AP_CHECK_RET2}	spectral enable radio 2
${AP_CHECK_RET3}	spectral enable radio 3
${AP_CHECK_RET4}	spectral enable

*** Test Cases ***
fss_auto_test：(no) spectral enable radio x 
	#****************参数配置，目前需要依据特定环境修改配置***********************#
	#${AC_IP}			Set variable	172.30.103.194								#变量存放在../variables/ac_config.py文件中
	#${AC_PORT}			Set variable	23											#这里存放是作为局部变量
	
	${Password}			Catenate		ruijie										#拼接字符串
	${Password_op}		Catenate		en											#拼接字符串
	${Password1}		Set variable	apdebug										#设置字符串，局部变量要设置或者拼接
	
	#************AC 配置spectral enable radio 1********#
	Telnet.Open Connection  host=${AC_IP}  port=${AC_PORT}							#telnet 到AC上
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s									#读数据直到出现（>或者#）返回AC 的命令行
	
	#************AC 简单检查需要配置的AP是否已经上线，不考虑检查完又快速下线的场景********#
	${output}=	Execute Command		show ap-config summary | i ${AP_NAME}			#因为命令输出数据太多，所以不能获取到全部ap 列表信息，需要获取两次
	Telnet.Write Bare	\r\n
	${output}=		Read Until Prompt												#获取AC 上AP 列表信息
	Should Match	${output}	*${AP_NAME}*										#有同名AP 检查到
	Should Not Match	${output}	*Quit*											#检查到的AP没有处于离线状态
	
	#************AC 进入spectral配置模式********#
	Telnet.Write Bare	co															#进入AC配置模式
	Telnet.Write Bare	\r\n	
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s
	Telnet.Write Bare	ap-config ${AP_MAC}
	Telnet.Write Bare	\r\n
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s ap								#查看AC 是否进入ap-config配置状态
	#************AC 初始化spectral 配置********#
	Telnet.Write 	no ${AC_TEST_CMD1}												#取消spectral enable radio 1配置
	Telnet.Write	no ${AC_TEST_CMD2}
	Telnet.Write	no ${AC_TEST_CMD3}
	Telnet.Write	no ${AC_TEST_CMD4}
	Telnet.Write Bare	\r\n
	${output}=		Read Until Prompt												#保存no 的全部执行步骤到output字符串
	Sleep	1s
	
	#************AC 进行spectral 配置测试********#
	${output}=          Telnet.Write		${AC_TEST_CMD1}
	${output}=          Telnet.Write		${AC_TEST_CMD2}
	${output}=          Telnet.Write		${AC_TEST_CMD3}
	${output}=			Read Until Prompt
	${output}=          Execute Command		show ap-config running ${AP_NAME}   	#这里出现失败很可能AP 已经离线，获取配置慢
	log to console	${output}
	Should Match	${output}	*${AC_CHECK_RET1}*
	Should Match	${output}	*${AC_CHECK_RET2}*
	Should Match	${output}	*${AC_CHECK_RET3}*
	#************AP检查AC 配置********#
	Telnet.Open Connection  host=${AP_IP}  port=${AP_PORT}							#telnet 到AP上
	log to console	${Password}														#向终端打印字符串
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  Username:  Password: 			#telnet 读取界面直到出现需要的字符串 Username： or Password：
	Telnet.Write Bare	${Password}													#输入密码
	Telnet.Write Bare	\r\n														#输入回车
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s									#telnet 读取界面直到出现需要的字符串：
	log to console	${Password_op}
	Telnet.Write Bare	${Password_op}
	Telnet.Write Bare	\r\n	
	log to console	${Password1}
	Telnet.Write Bare	${Password1}
	Telnet.Write Bare	\r\n	
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s
	Telnet.Write	${AP_CHECK_CMD}													#使用Telnet.Write 不用回车（\r\n）
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  ${AP_CHECK_RET1}					#AP检查配置，PASS 表示返回AP检查的结果通过
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  ${AP_CHECK_RET2}
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  ${AP_CHECK_RET3}
	Sleep	1s
	
	#************AC取消AP spectral enable radio x 配置********#
	Telnet.Switch Connection	1													#切换telent到第一个链接，注意Switch Connection中间是空格不是tab
	Telnet.Write Bare	\r\n
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s
	Telnet.Write 	no ${AC_TEST_CMD1}
	Telnet.Write	no ${AC_TEST_CMD2}
	Telnet.Write	no ${AC_TEST_CMD3}
	Telnet.Write	show ap-config running ${AP_NAME}
	Telnet.Write Bare	\r\n
	${output}	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s						#将读到的配置信息输入output
	log to console	${output}
	Should Not Match	${output}	*spectral enable*								#没有找到配置字符串表示成功 *用来修饰要匹配的字符串
	Should Match	${output}	${AC_CHECK_TMP}										#匹配到AP MAC 表示成功
	#************AP检查AC 取消的配置是否生效********#
	Telnet.Switch Connection	2
	Telnet.Write Bare	\r\n														#回车，生成新的命令行操作，等待输入命令
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s									#读输出，直到期望的规则(>|#)出现
	Telnet.Write	${AP_CHECK_CMD}	
	${output}	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s
	Should Not Match	${output}	*spectral enable*
	Sleep	1s																		#休息1s，再切换到AC

*** Test Cases ***
fss_auto_test：(no) spectral enable
	#************AC 配置AP spectral enable********#
	Telnet.Switch Connection	1
	Telnet.Write Bare	\r\n	
	Telnet.Read Until Prompt
	${output}=	Execute Command		${AC_TEST_CMD4}
	${output}=	Execute Command		show ap-config running ${AP_NAME}
	log to console	${output}
	Should Match	${output}	*${AC_CHECK_RET4}*
	#************AP 检测AC spectral enable 配置********#
	Telnet.Switch Connection	2
	Telnet.Write Bare	\r\n														#打了回车，那么读取数据需要偏移到最新的#贯标下
	Telnet.Read Until Prompt														#读取上面回车后的数据，将读取位置偏移到当前#
	${output}=	Execute Command		${AP_CHECK_CMD}									#保存到output的数据好像是还未读的# 与 #之间的数据
	Should Match	${output}	*spectral enable*
	Sleep	1s																		#休息1s，再切换到AC
	
	#************AC 取消配置AP spectral enable********#
	Telnet.Switch Connection	1
	Telnet.Write Bare	\r\n	
	Telnet.Read Until Prompt
	${output}=	Execute Command		no ${AC_TEST_CMD4}			
	log to console	${output}
	${output}=	Execute Command	show ap-config running ${AP_NAME}
	log to console	${output}
	#Telnet.Write Bare	\r\n
	#${output}=		Read Until Prompt	
	Should Not Match	${output}	*spectral enable*
	#************AP 检测AC 取消spectral enable 配置********#
	Telnet.Switch Connection	2
	Telnet.Write Bare	\r\n	
	Telnet.Read Until Prompt
	${output}=	Execute Command		${AP_CHECK_CMD}	
	Should Not Match	${output}	*spectral enable*
	Sleep	1s
	
	[Teardown]  Telnet.Close All Connections										#断开所有telnet 链接
    
