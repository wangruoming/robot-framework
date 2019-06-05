#!/usr/bin/python
import re
from selenium.common.exceptions import NoSuchElementException
 
string="tensorflow:Final best valid 0 loss=0.20478513836860657 norm_loss=0.767241849151384 roc=0.8262403011322021 pr=0.39401692152023315 calibration=0.9863265752792358 rate=0.0"
string1="*May 27 10:29:26:, %P2054-7-DEBUG: [classifiler][classifier_process_spectral_msg][1469]freq(5745) cnt(0) tstamp(-2037232662, 22286940, 0) \
		*May 27 10:29:26: %P2054-7-DEBUG: [classifiler][classifier_process_spectral_msg][1469]freq(5765) cnt(0) tstamp(-2036897476, 335186, 0) 	\
		*May 27 10:29:27: %P2054-7-DEBUG: [classifiler][classifier_process_spectral_msg][1469]freq(5785) cnt(0) tstamp(-2036610641, 286835, 1) 	\
		*May 27 10:29:27: %P2054-7-DEBUG: [classifiler][classifier_process_spectral_msg][1469]freq(5805) cnt(0) tstamp(-2036275272, 22335369, 0)	\
		*May 27 10:29:27: %P2054-7-DEBUG: [classifiler][classifier_process_spectral_msg][1469]freq(5805) cnt(0) tstamp(-2036275272, 335369, 0)"

pattern = re.compile(r'(?<=calibration=)\d+\.?\d*')
pattern.findall(string)
print ('%s: +' %'string')
print ('%s: +' %string)					#打印字符串变量
print ('%s: +' %pattern)					#打印字符串变量
print ('%s: +' %pattern.findall(string))					#打印字符串变量

#pattern1 = re.compile(r'(?<=, \d+\.?\d*')
totalCount = re.sub("\D", "", string1)		#在string1 字符串中，找到非数字的字符（正则表达式中'\D'表示非数字），并用""替换
print ('%s: +' %totalCount)					#打印字符串变量

#str.split('分隔符',num)
#str -- 分隔符，默认为空格。
#num -- 分割次数。
#返回分割后的字符串列表
#
error_cnt = 0
totalCount1 = string1.split(', ')
print ('len=%d' %len(totalCount1))				#打印整数，字符串列表长度
print ('%s: +' %totalCount1)					#打印字符串变量
print ('%s: +' %'-------------------------------------------------------------')
for index in range(len(totalCount1) - 1):
	print ('index=%d' %index)
	if index%1 == 0: 
		#print ('%s' %totalCount1[index])						#打印字符串变量
		try:
			timeus = int(totalCount1[index])
		except Exception as e:									#python3 的语法，python2.7的语法except Exception,e:
			print ('output:%s' %totalCount1[index])
			continue											#从字符串中获取时间失败，继续再下一个字符串中获取
		if timeus < 1000 * 1000:								#时间小于1s
			print ('time=%dus' %timeus)							#打印整型变量
		else:
			print ('time interval error')
			error_cnt = error_cnt + 1
			if error_cnt >= 2:
				print ('failure:error_cnt=%d' %error_cnt)
			else:
				print ('ignore:error_cnt=%d' %error_cnt)
		
	else:
		print ('index=%d--end' %index)
#for index in range(len(totalCount1)):
#   print 'current str=', totalCount1[index]
print ('%s: +' %'-------------------------------------------------------------')
#ok
#print ('0:%s' %totalCount1[0])					#打印字符串变量
#print ('1:%s' %totalCount1[1])					#打印字符串变量
#print ('2:%s' %totalCount1[2])					#打印字符串变量
#print ('3:%s' %totalCount1[3])					#打印字符串变量
#print ('%s: +' %totalCount1[4])					#打印字符串变量
#print ('%s: +' %totalCount1[5])					#打印字符串变量
#print ('%s: +' %totalCount1[6])					#打印字符串变量
#print ('%s: +' %totalCount1[7])					#打印字符串变量
#print ('%s: +' %totalCount1[8])					#打印字符串变量
#print ('%s: +' %totalCount1[9])					#打印字符串变量
#

#print pattern.findall(string)
#print re.findall(r"\d+\.?\d*",string)
 
# ['1.45', '5', '6.45', '8.82']