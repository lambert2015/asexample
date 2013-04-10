import sys
import math
print(type(1))
print(isinstance(1, int))
print(1+1)
print(1+1.)
print(float(2))
print(int(2.5))
print(int(-2.5))
print(11/2)
print(11//2)
print(-11//2)
print(11.//2)
print(11**2)
print(11%2)

print(math.pi)
print(math.sin(5))
print(math.tan(math.pi/4))

def is_it_true(anything):
	if anything:
		print("yes,it`s true")
	else:
		print("no,it`s false")

is_it_true(1)

aList = [5,6,7,8,9,20]
print(aList)
aList += [2,200]
print(aList)
aList.append(True)
print(aList)
aList.extend(["ddd","sax"])
print(aList)
aList.insert(0,"sdf")
print(aList)
del aList[0]
print(aList)
aList.append(6)
aList.remove(6)
print(aList)
aList.remove(6)
print(aList)
print(aList.pop())


a_tuple = (1,2,3,4,5)
print(a_tuple)
print(a_tuple[-1])
(MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY) = range(7) 
print(MONDAY)

