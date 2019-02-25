"""
This program demonstrates how Lambda function or List comprehension can be used in Python
"""
#Build a list from range
print("Sqares of numbers from 0 to 19")
l=[x**2 for x in range(20)]
print(l)

#Value of pi for diffrent precisions
from math import pi
print("Value of pi rounded to two decimal places")
print(round(pi,2))
print("Value of pi rounded to 0-5 decimal places")
rpi=[round(pi,x) for x in range(6)]
print(rpi)

#Trimming strings
print("Trimming all elements of of array")
s=["one ","two ","three"]
print(s)
print([s1.strip() for s1 in s])

#Tuples
print("Squares of numbers from 0-5")
sq=[(x,x**2) for x in range(6)]
print(sq)

#list of lists
print("Flattening a list of list")
lol=[[1,2,3],[4,5,6],[7]]
print(lol)
print([n for li in lol for n in li] )

mtx=[[1,2,3,4],[5,6,7,8],[9,10,11,12]]
print ("Matrix")
print(mtx)
print ("Columns of the Matrix")
print([[r[i] for r in mtx] for i in range(len(mtx)+1) ])
