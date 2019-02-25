#!/bin/python3
"""
This program takes length of three sides and determines if that make a triangle with non-zero area
This is done based on Heron's formula, which says
 area=sqrt(s(s-a)(s-b)(s-c)) where s=(a+b+c)/2
For Area to be greater than 0 , all sides should be smaller than s
"""

import sys
import os


def triangleOrNot(a, b, c):
	result=[]
	for i,j,k in zip(a,b,c):
		s=(i+j+k)/2
		if s<=max([i,j,k]):
			result.append('No')
		else:
			result.append('Yes')
	return result
			
	
if __name__ == "__main__":
    ###f = open(os.environ['OUTPUT_PATH'], 'w')

    a_cnt = 0
    a_cnt = int(input())
    a_i = 0
    a = []
    while a_i < a_cnt:
        a_item = int(input())
        a.append(a_item)
        a_i += 1


    b_cnt = 0
    b_cnt = int(input())
    b_i = 0
    b = []
    while b_i < b_cnt:
        b_item = int(input())
        b.append(b_item)
        b_i += 1


    c_cnt = 0
    c_cnt = int(input())
    c_i = 0
    c = []
    while c_i < c_cnt:
        c_item = int(input())
        c.append(c_item)
        c_i += 1


    res = triangleOrNot(a, b, c);
    print(res)
   # for res_cur in res:
    #    f.write( str(res_cur) + "\n" )


   # f.close()
