#!/usr/bin/python

import string

allascii = string.ascii_lowercase

mp = {'k':'m', 'o':'q', 'e':'g'}

str1 = "g fmnc wms bgblr rpylqjyrc gr zw fylb. rfyrq ufyr amknsrcpq ypc dmp. bmgle gr gl zw fylb gq glcddgagclr ylb rfyr'q ufw rfgq rcvr gq qm jmle. sqgle qrpgle.kyicrpylq() gq pcamkkclbcb. lmu ynnjw ml rfc spj."
str3 = "map.html"

lenascii = len(allascii)
def translate(strr):
   maptable = string.maketrans(string.ascii_lowercase,
                               string.ascii_lowercase[2:] + 'ab')
   str2 = string.translate(strr, maptable)
   return str2
print 'before translate: %s' % str1
print 'and then        : %s' % translate(str1)

print translate(str3[:3])


