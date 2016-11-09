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

##########################################################

counter = 0

counter_queue = queue.Queue()

def counter_manager():
    """My job is to increment the counter and print the result"""
    global counter

    while True:
        increment = counter_queue.get()
        fuzz()
        old_count = counter
        fuzz()
        counter = old_count + increment
        fuzz()
        print_queue.put([
            "the count is %d" % counter,
            "----------------------"
        ])
        fuzz()
        counter_queue.task_done()

t = threading.Thread(target=counter_manager)
t.daemon = True
t.start()
del t

################################################

print_queue = queue.Queue()

def print_manager():
    "I have excusive rights to call the print keyword"
    while True:
        job = print_queue.get()
        fuzz()
        for line in job:
            print(line, end="")
            fuzz()
            print()
            fuzz()
        print_queue.task_done()
        fuzz()

t = threading.Thread(target=print_manager)
t.daemon = True
t.start()
del t

#################################################

def worker():
    """My job is to increment the counter and print the current count"""
    counter_queue.put(1)
    fuzz()

print_queue.put(["starting up"])
fuzz()

worker_threads = []
for i in range(10):
    t = threading.Thread(target=worker)
    worker_threads.append(t)
    t.start()
    fuzz()
for t in worker_threads:
    fuzz()
    t.join()

counter_queue.join()
fuzz()
print_queue.put(["finishing up"])
fuzz()
print_queue.join()
fuzz()
