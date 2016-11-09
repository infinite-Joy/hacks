"""
https://www.youtube.com/watch?v=Bv25Dwe84g0
Thinking about Concurrency, Raymond Hettinger, Python core developer
"""

import urllib.request
import threading
import time
import random
import queue

FUZZ = True
def fuzz():
    """
    fuzzing is a technique to make the race condition errors more visible
    """
    if FUZZ:
        time.sleep(random.random())

counter = 0

def worker():
    """My job is to increment the counter and print the result"""
    global counter

    counter += 1
    print("the count is %d" % counter)
    print("-------------------------")

print("starting up")
for i in range(10):
    worker()
print("finishing up")
