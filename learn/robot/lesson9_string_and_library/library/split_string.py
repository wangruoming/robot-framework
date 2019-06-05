import re
import time

def test_split_string(string):
	string_list = string.split(', ')
	print ('len=%d' %len(string_list))				#打印整数，字符串列表长度
	print ('string_list=%s\n' %string_list)					#打印字符串变量
	print ('%s\n' %'-------------------------------------------------------------')
	for index in range(len(string_list) - 1):
		print ('index=%d' %index)
		if index%2 == 1: 
			#print ('%s' %string_list[index])						#打印字符串变量
			timeus = int(string_list[index])
			if timeus < 1000 * 1000:								#时间小于1s
				print ('time=%dus' %timeus)							#打印整型变量
			else:
				print ('time interval error')
				return -1
		else:
			print ('index=%d-----end' %index)		
			#print ('%s\n' %'-------------------------------------------------------------1')  python 的for循环和if调剂判断是通过tab 表对齐来判断的
	print ('%s\n' %'-------------------------------------------------------------')
	return 1