#!/usr/bin/env python
from random import randrange
from flask import Flask
import time

app = Flask('crash-test-app')
success_rate = 90
hit_count = 0

# used by readiness probe
@app.route('/readiness')
def warm_up():
    global hit_count
    if hit_count < 1:
        time.sleep(5)

    hit_count = hit_count + 1
    return "success\n", 200

# used by liveliness probe
@app.route('/liveliness')
def health_check():
    if randrange(1, 100) < success_rate:        
        return "success\n", 200        
    else:        
        return "crash\n", 500

app.run(host = '0.0.0.0', port = 8080)
