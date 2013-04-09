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
	