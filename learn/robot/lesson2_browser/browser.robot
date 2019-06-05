*** Settings ***
Library           SeleniumLibrary

*** Test Cases ***
wrm Baidu search case #关键字是做一个说明，会出现到终端
    Open Browser	http://www.baidu.com    chrome
	Input text		name=wd    robot framework 学习
	click button	id=su 
    #Input text		id=kw    robot framework
    #click button	id=su   
	#Sleep  3s     #睡3s
    #close Browser
	
*** Test Cases ***
test case1
    ${hi}	Catenate	hello	 world！ #变量hi 是hello 链接 world！ 组成，中间一个tab一个空格
	${hi2}	Catenate	hello	world！ #变量hi 是hello 链接 world！ 中间一个tab
	${time}	Get Time					#获取时间
	log		${hi}						#打印变量hi
	log		${hi2}						#打印变量hi
	log		${time}