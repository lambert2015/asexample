# -*_ coding: utf-8 -*-

import os
import glob

print(os.getcwd())
print(os.path)
pathname = '/Users/pilgrim/diveintopython3/examples/humansize.py'
(dirname,filename) = os.path.split(pathname)
print(dirname)
print(filename)

metadata = os.stat('test2.py')
print(metadata.st_mtime)

import time
print(time.localtime(metadata.st_mtime))

print(metadata.st_size)

print("test2.py real path :",os.path.realpath('test2.py'))

a_list = [1,2,3,4,5]
b_list = [elem * 2 for elem in a_list]
print(a_list)
print(b_list)
