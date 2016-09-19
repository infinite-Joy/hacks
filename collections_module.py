from __future__ import print_function
# refs: https://www.accelebrate.com/blog/using-defaultdict-python/
#         https://docs.python.org/2/library/collections.html
#       http://book.pythontips.com/en/latest/collections.html
#       http://stackoverflow.com/questions/19629682/ordereddict-vs-defaultdict-vs-dict
#       http://stackoverflow.com/questions/12555967/is-the-defaultdict-in-pythons-collections-module-really-faster-than-using-setde
# If you are working with dicts then consider calling the default dicts directory


# the below throws key error
try:
    some_dict = {}
    some_dict['colours']['favourite'] = "yellow"
except KeyError, e:
    print("Threw key error at:")
    print(e)

#Solution:
import collections
import json

tree = lambda: collections.defaultdict(tree)
some_dict = tree()
# below will create non existent keys
some_dict['colours']['favourite'] = "yellow" # Works fine
print(json.dumps(some_dict))
# Output: {"colours": {"favourite": "yellow"}}

# set a default value for non existent keys:

ice_cream = collections.defaultdict(lambda: 'Vanilla')
ice_cream['Sarah'] = 'Chunky Monkey'
ice_cream['Abdul'] = 'Butter Pecan'
print(ice_cream['Sarah']) # out: 'Chunky Monkey'
print(ice_cream['Joe']) # out: 'Vanilla'

# a fast and flexile use case is to
# use itertools.repeat() which can supply any constant value:

import itertools
def constant_factory(value):
    return itertools.repeat(value).next
d = collections.defaultdict(constant_factory('<missing>'))
d.update(name='John', action='ran')
print('%(name)s %(action)s to %(object)s' % d)

# performance evaluation

from collections import defaultdict
from collections import OrderedDict

try:
    t=unichr(100)
except NameError:
    unichr=chr

def f1(li):
    '''defaultdict'''
    d = defaultdict(list)
    for k, v in li:
        d[k].append(v)
    return d.items()

def f2(li):
    '''setdefault'''
    d={}
    for k, v in li:
        d.setdefault(k, []).append(v)
    return d.items()

def f3(li):
    '''OrderedDict'''
    d=OrderedDict()
    for k, v in li:
        d.setdefault(k, []).append(v)
    return d.items()      


if __name__ == '__main__':
    import timeit
    import sys
    print(sys.version)
    few=[('yellow', 1), ('blue', 2), ('yellow', 3), ('blue', 4), ('red', 1)]
    fmt='{:>12}: {:10.2f} micro sec/call ({:,} elements, {:,} keys)'
    for tag, m, n in [('small',5,10000), ('medium',20,1000), ('bigger',1000,100), ('large',5000,10)]:
        for f in [f1,f2,f3]:
            s = few*m
            res=timeit.timeit("{}(s)".format(f.__name__), setup="from __main__ import {}, s".format(f.__name__), number=n)
            st=fmt.format(f.__doc__, res/n*1000000, len(s), len(f(s)))
            print(st)
            s = [(unichr(i%0x10000),i) for i in range(1,len(s)+1)]
            res=timeit.timeit("{}(s)".format(f.__name__), setup="from __main__ import {}, s".format(f.__name__), number=n)
            st=fmt.format(f.__doc__, res/n*1000000, len(s), len(f(s)))
            print(st)            
        print()
