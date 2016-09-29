#!/usr/bin/python

import re
import sys
from pprint import pprint

#sys.path.append('/usr/lib/python2.7/dist-packages')
import requests
import socket

socket.setdefaulttimeout(500)

nothing='peak.html'
while nothing is not None:
   url = 'http://www.pythonchallenge.com/pc/def/linkedlist.php?nothing=%s' % nothing
   resp = requests.get(url)

   respText = resp.text
   print respText

   if 'next nothing' in respText:
      pat = '[0-9]{1,15}'
      nothings = re.findall(pat, respText)
      if len(nothings) is 1:
         nothing = nothings[0]
      else:
         break
