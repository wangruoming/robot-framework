import re
import time

def test_split_string(string):
	error_cnt = 0													#做库需要使用局部变量
	string_list = string.split(', ')
	print ('len=%d' %len(string_list))								#打印整数，字符串列表长度
	print ('string_list=%s\n' %string_list)							#打印字符串变量
	print ('%s\n' %'-------------------------------------------------------------')
	for index in range(len(string_list) - 1):
		print ('index=%d' %index)
		if index%1 == 0: 											#遍历字符列表里的数据
			#print ('%s' %string_list[index])						#打印字符串变量
			try:
				timeus = int(string_list[index])					#尝试将字符列表的数据转化为整型数据
			except Exception as e:									#python3 的语法，python2.7的语法except Exception,e:，表示try失败处理
				print ('output:%s' %string_list[index])				#打印
				continue											#从字符串中获取时间失败，继续再下一个字符串中获取
			timeus = int(string_list[index])
			if timeus < 1000 * 1000:								#时间小于1s
				print ('time=%dus' %timeus)							#打印整型变量
			else:
				print ('%s' %string_list[index])					#打印字符串变量
				print ('time interval error')
				error_cnt = error_cnt + 1							#第一个时间间隔大于1s不做错误处理，因为第一个时间间隔和上一个间隔可能很大
				if error_cnt >= 2:									#时间间隔大于1S两次，返回-1，表示出错
					print ('failure:error_cnt=%d' %error_cnt)
					return -1
				else:
					print ('ignore:error_cnt=%d' %error_cnt)
		else:
			print ('index=%d-----end' %index)		
			#print ('%s\n' %'-------------------------------------------------------------1')  python 的for循环和if调剂判断是通过tab 表对齐来判断的
	print ('%s\n' %'-------------------------------------------------------------')
	return 1