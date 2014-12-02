#!/usr/bin/python -u

import os
import pickle
from pprint import pprint

with open('5-peakhell-banner.p', 'r') as f:
    content = pickle.load(f)

for l in content:
    line = ''
    for c, n in l:
        line += c*n
    print line

