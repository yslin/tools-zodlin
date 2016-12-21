#!/usr/bin/env python
# -*- coding: utf-8 -*-
#===============================================================================
# Copyright 2012 zod.yslin
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# Author: zod.yslin
# Email: 
# File Name: Listing1.py
# Description: 
#   pyflakes example.
# Edit History: 
#   2012-01-27    File created.
#===============================================================================
"""
"""

import string

module_variable = 0

def functionName(self, int):
    local = 5 + 5
    module_variable = 5*5
    return module_variable

class my_class(object):
    
    def __init__(self, arg1, string):
        self.value = True
        return

    def method1(self, str):
        self.s = str
        return self.value

    def method2(self):
        return
        print 'How did we get here?'
    
    def method1(self):
        return self.value + 1
    method2 = method1
    
class my_subclass(my_class):
    
    def __init__(self, arg1, string):
        self.value = arg1
        return
