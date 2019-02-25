"""
Demonstration of Set operations
Set does not allow duplicates
"""
t={1,2,3,3,1,4}
print("Initial value of the set")
print(t)
print("Length of the set")
print(len(t))
u=t,(5,6,7,"hahah")
print("Tuple made of the set and another tuple")
print(u)
print("Length of the Tuple")
print(len(u))
print("converting to a list")
l=list(u)
print(l)
print([x  for t1 in u for x in t1])

a=set('test word')
b=set("duplicate")
print("Set a made from characters from 'test word'")
print(a)
print("Set b made from characters from 'duplicate'")
print(b)
print("set opertion a-b")
print(a-b)
print("set opertion a^b")
print(a^b)
print("set opertion a&b")
print(a&b)
print("set opertion a|b")
print(a|b)
