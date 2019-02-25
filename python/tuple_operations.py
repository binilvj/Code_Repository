"""
Demonstration of Tuple operations
"""
t=1,2,3,4
print("Tuple t and it's length")
print(t)
print(len(t))
u=t,(5,6,7,"hahah")
print("Concatenated Tuple u and it's length")
print(u)
print(len(u))
print("Tuple u converted a list using list function and list comprehension")
l=list(u)
print(l)
print([x  for t1 in u for x in t1])
