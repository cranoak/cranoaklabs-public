# pairs = [(1, 'one'), (2, 'two'), (3, 'three'), (4, 'four')]
# pairs.sort(key=lambda pair: pair[1])
# print(pairs)
import sys

for n in sys.argv:
  """
  this is a document.  like a comment but you can access 
  by using __doc__
  
  """
    print(n)

num = int(sys.argv[1])
num2 = int(sys.argv[2])
num3 = int(sys.argv[3])

x = lambda a,b : a + b
print(x(num, num2))

x = lambda a,b,c : a + b + c
print(x(num, num2, num3))