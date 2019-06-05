*** Settings ***
Library     String


*** Test Cases ***
Test Robot Framework Logging
	[Documentation]    打印log.
  Log   Test Logging
  Log Many  First Entry   Second Entry
  Log To Console  Display to console while Robot is running

Test For Loop
	[Documentation]    for 循环.
    : FOR    ${INDEX}    IN RANGE    1    3							#默认循环的次数1-4，就是循环三次（1,2,3），1-3就是循环2次（1,2）#
    \    Log    ${INDEX}
    \    ${RANDOM_STRING}=    Generate Random String    ${INDEX}
    \    Log    ${RANDOM_STRING}
	
Test For Loop and if
	[Documentation]    for 循环.加条件判断
    : FOR    ${INDEX}    IN RANGE    1    4							#默认循环的次数1-4，就是循环三次（1,2,3），1-3就是循环2次（1,2）#
    \    Log    ${INDEX}											#for 循环链接的关键字是\，\ 有多行就表示for的运行实体是哪些
        ${RANDOM_STRING}=    Generate Random String    ${INDEX}
        Log    ${RANDOM_STRING}
		Run Keyword If		${INDEX}==1	log	${INDEX}				#数字对比，index等于1，输出index，注意：log后面是tab#
		...	ELSE IF	${INDEX}==2	log	${INDEX}
		...	ELSE	log	${INDEX}									#...（三点） 是if/ else if/ else 的关键字，用来区分是同一个if语句的，并且... 和 else if 是用tab分割不是空格
	
Test For Loop and if 1,2,3 都打印
	[Documentation]    for 循环.加条件判断
    : FOR    ${INDEX}    IN RANGE    1    4							#默认循环的次数1-4，就是循环三次（1,2,3），1-3就是循环2次（1,2）#
    \    Log    ${INDEX}											#for 循环链接的关键字是\，\ 有多行就表示for的运行实体是哪些
    \    ${RANDOM_STRING}=    Generate Random String    ${INDEX}
    \   Log    ${RANDOM_STRING}
	\	Run Keyword If		${INDEX}==1	log	${INDEX}				#数字对比，index等于1，输出index，注意：log后面是tab#
	\	...	ELSE IF	${INDEX}==2	log	${INDEX}
	\	...	ELSE	Log Many	test	$(INDEX)					#...（三点） 是if/ else if/ else 的关键字，用来区分是同一个if语句的，并且... 和 else if 是用tab分割不是空格
	#Log Many 之间是空格， Log Many 和 First Entry之间是tab，First Entry 和 Second Entry 之间是tab
	
#Run Keyword And Ignore Error