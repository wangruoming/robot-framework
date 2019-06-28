import re
import time

#retval=False  全局变量不能修改
#所有匹配子字符串（str1）的string，都必须匹配子字符串arg
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
		
#所有匹配子字符串（str1）的string，需要至少一组能匹配子字符串arg
def fss_check_string1(string, str1, arg):
	print ('str1=%s\n' %str1)															#打印参数2
	print ('arg=%s\n' %arg)																#打印参数3
	retval=False
	error_cnt = 0																		#做库需要使用局部变量
	string_list = string.split('\r\n')													#分割符号
	print ('len=%d' %len(string_list))													#打印整数，字符串列表长度
	print ('string_list=%s\n' %string_list)												#打印字符串变量
	print ('%s\n' %'-------------------------------------------------------------')		#分割线，下面为打印string_list里面的每一个字符串
	for index in range(len(string_list) - 1):
		print ('index=%d' %index)
		if index%1 == 0: 																#遍历字符列表里的数据
			#print ('%s' %string_list[index])											#打印字符串变量
			if str1 in string_list[index]:
				print ('find:%s' %string_list[index])									#打印找到匹配str1的字符串
				if arg in string_list[index]:
					print ('true:%s' %string_list[index])								#打印找到匹配arg的字符串
					retval = True
				else:
					print ('false:%s' %string_list[index])								#打印找到匹配arg的字符串
			else:
				print ('no find:%s' %string_list[index])								#打印没有找到匹配str1的字符串		
		else:
			print ('index=%d-----end' %index)		
			#print ('%s\n' %'-------------------------------------------------------------1')  python 的for循环和if调剂判断是通过tab 表对齐来判断的
	print ('%s\n' %'-------------------------------------------------------------')
	if retval == True:
		return 1
	else:
		return -1
		
#所有匹配子字符串（str1）的string，需要至少一组能匹配子字符串arg
def fss_check_string_value(string, str1):
	print ('str1=%s\n' %str1)										#打印参数2
	retval=False
	error_cnt = 0													#做库需要使用局部变量
	string_list = string.split('\r\n')								#分割符号
	print ('len=%d' %len(string_list))								#打印整数，字符串列表长度
	print ('string_list=%s\n' %string_list)							#打印字符串变量
	print ('%s\n' %'-------------------------------------------------------------')		#分割线，下面为打印string_list里面的每一个字符串
	for index in range(len(string_list)):
		print ('index=%d' %index)
		if index%1 == 0: 											#遍历字符列表里的数据
			#print ('%s' %string_list[index])						#打印字符串变量
			if str1 in string_list[index]:
				print ('find:%s' %string_list[index])				#打印找到匹配str1的字符串
				string_list1 = string_list[index].split('=')
				print ('find >>>>>>>>>>>>>>')
				print ('len=%d' %len(string_list1))							#打印整数，字符串列表长度
				print ('string_list1=%s\n' %string_list1)					#打印字符串变量
				for index1 in range(len(string_list1)):						#for 循环从index1等于0开始，到小于range的范围结束，若是range是2， 那么还能遍历到index1等于1
					print ('    index1=%d' %index1)
					try:
						value = int(string_list1[index1])					#尝试将字符列表的数据转化为整型数据
					except Exception as e:									#python3 的语法，python2.7的语法except Exception,e:，表示try失败处理
						print ('    output:%s' %string_list1[index1])		#打印
						continue											#从字符串中获取时间失败，继续再下一个字符串中获取
					print ('    value=%d' %value)
					if 0 <= value <= 255:
						retval = True
					else:
						return -1
				print ('find end>>>>>>>>>>')
				"""
				if arg in string_list[index]:
					print ('true:%s' %string_list[index])				#打印找到匹配arg的字符串
					retval = True
				else:
					print ('false:%s' %string_list[index])				#打印找到匹配arg的字符串
				"""
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
		
#查找子字符串在字符串中出现的次数
def fss_detected_interference(string, str1):
	print ('str1=%s\n' %str1)										#打印参数2
	retval = 0														#做库需要使用局部变量
	string_list = string.split('\r\n')								#分割符号
	print ('len=%d' %len(string_list))								#打印整数，字符串列表长度
	print ('string_list=%s\n' %string_list)							#打印字符串变量
	print ('%s\n' %'-------------------------------------------------------------')		#分割线，下面为打印string_list里面的每一个字符串
	for index in range(len(string_list)):
		print ('index=%d' %index)
		if index%1 == 0: 											#遍历字符列表里的数据
			#print ('%s' %string_list[index])						#打印字符串变量
			if str1 in string_list[index]:
				print ('find:%s' %string_list[index])				#打印找到匹配str1的字符串
				print ('find >>>>>>>>>>>>>>')
				retval = retval + 1
				print ('find end>>>>>>>>>>>')
			else:
				print ('no find:%s' %string_list[index])				#打印没有找到匹配str1的字符串		
		else:
			print ('index=%d-----end' %index)		
			#print ('%s\n' %'-------------------------------------------------------------1')  python 的for循环和if调剂判断是通过tab 表对齐来判断的
	print ('%s\n' %'-------------------------------------------------------------')
	return retval