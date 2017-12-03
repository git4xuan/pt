#!/bin/env python
# -*- coding: utf-8 -*-
#coding=utf-8

### according to base bbr with change kernel part.

### python response commands

### ready to passimport os
import sys
import commands


t1,t2 = commands.getstatusoutput("bash base/bbr_base.sh")
print(t1)
print(t2)
print(sys.getdefaultencoding())
