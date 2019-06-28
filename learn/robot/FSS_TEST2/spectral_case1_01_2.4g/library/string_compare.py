import re
import time

#retval=False  全局变量不能修改
#必须匹配所有字符串
def fss_check_string(string, str1, arg):
	print ('str1=%s\n' %str1)										#打印参数2
	print ('arg=%s\n' %arg)											#打印参数3
	retval=False
	error_cnt = 0													#做库需要使用局部变量
	string_list = string.split('\r\n')								#分割符号
	print ('len=%d' %len(string_list))								#打印整数，字符串列表长度
	print ('string_list=%s\n' %string_list)							#打印字符串变量
	print ('%s\n' %'-------------------------------------------------------------')		#分割线，下面为打印string_list里面的每一个字符串
	for index in range(len(string_list) - 1):
		print ('index=%d' %index)
		if index%1 == 0: 											#遍历字符列表里的数据
			#print ('%s' %string_list[index])						#打印字符串变量
			if str1 in string_list[index]:
				print ('find:%s' %string_list[index])				#打印找到匹配str1的字符串
				if arg in string_list[index]:
					print ('true:%s' %string_list[index])				#打印找到匹配arg的字符串
					retval = True
				else:
					return -1
			else:
				print ('no find:%s' %string_list[index])				#打印没有找到匹配str1的字符串		
		else:
			print ('index=%d-----end' %index)		
			#print ('%s\n' %'-------------------------------------------------------------1')  python 的for循环和if调剂判断是通过tab 表对齐来判断的
	print ('%s\n' %'-------------------------------------------------------------')
	if retval == True:
		return 1
	else:
		return -1
		
#有字符串匹配就可以
def fss_check_string1(string, str1, arg):
	print ('str1=%s\n' %str1)										#打印参数2
	print ('arg=%s\n' %arg)											#打印参数3
	retval=False
	error_cnt = 0													#做库需要使用局部变量
	string_list = string.split('\r\n')								#分割符号
	print ('len=%d' %len(string_list))								#打印整数，字符串列表长度
	print ('string_list=%s\n' %string_list)							#打印字符串变量
	print ('%s\n' %'-------------------------------------------------------------')		#分割线，下面为打印string_list里面的每一个字符串
	for index in range(len(string_list) - 1):
		print ('index=%d' %index)
		if index%1 == 0: 											#遍历字符列表里的数据
			#print ('%s' %string_list[index])						#打印字符串变量
			if str1 in string_list[index]:
				print ('find:%s' %string_list[index])				#打印找到匹配str1的字符串
				if arg in string_list[index]:
					print ('true:%s' %string_list[index])				#打印找到匹配arg的字符串
					retval = True
				else:
					print ('false:%s' %string_list[index])				#打印找到匹配arg的字符串
			else:
				print ('no find:%s' %string_list[index])				#打印没有找到匹配str1的字符串		
		else:
			print ('index=%d-----end' %index)		
			#print ('%s\n' %'-------------------------------------------------------------1')  python 的for循环和if调剂判断是通过tab 表对齐来判断的
	print ('%s\n' %'-------------------------------------------------------------')
	if retval == True:
		return 1
	else:
		return -1