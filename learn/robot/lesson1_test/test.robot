*** Test Cases ***


test case1
	${hi}	Catenate	hello
	${a}    Set variable    python				#设置字符串变量
    log to console	\n hello robot framework	#换行，log 打印到终端
	log to console	\n ${hi}					#换行，log 打印到终端
	log to console	\n ${a}