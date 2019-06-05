*** Settings ***
Library  Telnet  prompt=(>|#|:)$  prompt_is_regexp=yes
Library  SSHLibrary
Library  Collections
Library  String    
#Variables  yaml_files/rcms.yaml
#Variables  yaml_files/switch.yaml
#Variables  yaml_files/image_server.yaml
#Variables  yaml_files/sta.yaml
#Variables  yaml_files/ac.yaml
#Variables  yaml_files/ap.yaml
#Suite Setup  setup_do
#Suite Teardown  teardown_do

*** Test Cases ***
ap_walker
	${Password}	Catenate	ruijie												#拼接字符串
	${Password_op}	Catenate	en												#设置字符串
	${Password1}	Set variable	apdebug										#设置字符串
	Telnet.Open Connection  host=172.30.103.194  port=23						#telnet 到AC（172.30.103.194）上
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s
	
	Telnet.Open Connection  host=172.30.103.253  port=23						#telnet 到AC（172.30.103.253）要链接的设备
	Sleep  1s																	#要睡眠的时间
	log to console	${Password}													#向终端打印字符串
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  Username:  Password: 		#telnet 读取界面直到出现需要的字符创 Username： or Password：
	Telnet.Write Bare  ${Password}												#输入密码
	Telnet.Write Bare  \r\n														#输入回车
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  880:							#telnet 读取界面直到出现需要的字符创 Username： or Password： or 880：
	log to console	${Password_op}
	Telnet.Write Bare	${Password_op}
	Telnet.Write Bare	\r\n	
	log to console	${Password1}
	Telnet.Write Bare	${Password1}
	Telnet.Write Bare	\r\n	
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  880:
	Telnet.Write	show running-config | be wids
	Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  wids
	[Teardown]  Telnet.Close All Connections									#断开所有telnet 链接
    #visit_via_telnet  ${dev.host}  ${dev.port}
    
#*** Keywords ***
#setup_do
#    No Operation
#    
#teardown_do
#    No Operation
#    
#visit_via_telnet
#    [Arguments]  ${host}  ${port}
#
#    Telnet.Open Connection  host=${host}  port=${port}
#    Sleep  3s
#    ${CTRL_C}  Evaluate  chr(int(3))
#    Telnet.Write Bare  ${CTRL_C}
#    Telnet.Read Until Regexp  (>|#)  \\sRETURN\\s  Username:  Password:
#    [Teardown]  Telnet.Close All Connections

#visit_via_ssh
#    [Arguments]  ${host}  ${username}  ${password}
#
#    SSHLibrary.Open Connection  host=${host}
#    SSHLibrary.Login  ${username}  ${password}
#    [Teardown]  SSHLibrary.Close All Connections