#!/usr/bin/python 

import os
import re
from pprint import pprint
import zipfile

index = '90052'

zf = zipfile.ZipFile('./channel.zip', 'r')
finalStr = ''
while index is not None:
   fn = '%s.txt' % index

   info = zf.getinfo(fn)
   finalStr += info.comment
   with zf.open(fn, 'r') as f:
      line = f.read()
      pat = '[0-9]+'
      cont = re.findall(pat, line)

      print line
      if len(cont) is not 0:
         index = cont[0]
      else:
         index = None

print finalStr