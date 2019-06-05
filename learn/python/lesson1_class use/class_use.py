#!/usr/bin/python
import re
import time

#类的定义 和 使用, 在类里面不能用tab，只能用空格作为缩进
class Study(object):
    """To Study python Class"""
    def __init__(self, math, chinese=91, english=90):
        self.math = math
        self.chinese = chinese
        self.english = english

    def total_goal(self, num=1):
        print ("total goal：")										#python3 print语法：print("%d:%s" %(1, "string")) 输出一个整型和一个字符串
        return (self.math + self.chinese + self.english) * num

#调用类
if __name__ == '__main__':											#调用函数，相当于C语言main，作为程序主入口
    really_goal = Study(127)										#Study 是类， really_goal 相当于类的具体变量，且用127 初始化了math
    want_goal = Study(141, 110, 115)								#Study 是类， want_goal 相当于类的具体变量，且用141 初始化了math，语文和英语分别是110/115
    print ("%d" %really_goal.total_goal())
    print ("%d" %really_goal.total_goal(2))
    print ("%d-%d" %(want_goal.total_goal(), want_goal.total_goal(3)))
    #print really_goal.total_goal(2)								#python2.7的语法
    #print want_goal.total_goal()
    #print want_goal.total_goal(3)
    time.sleep(10)													#休眠10s

"""																				#python 三对单引号或者三对双引号表示多行注释,#表示单行注释
C:\\Users\\wrm>python "E:\\learn\\python\\lesson1_class use\\class_use.py"		#在多行注释的时候反斜杠是转义字符，需要再加一个
total goal：
308
total goal：
616
total goal：
total goal：
366-1098
"""

'''																#python 三对单引号或者三对双引号表示多行注释,#表示单行注释
pattern = re.compile(r'(?<=calibration=)\d+\.?\d*')
pattern.findall(string)
print ('%s: +' %'string')
print ('%s: +' %string)					#打印字符串变量
print ('%s: +' %pattern)					#打印字符串变量
print ('%s: +' %pattern.findall(string))					#打印字符串变量
'''
"""
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
"""
#print pattern.findall(string)
#print re.findall(r"\d+\.?\d*",string)
 
# ['1.45', '5', '6.45', '8.82']
