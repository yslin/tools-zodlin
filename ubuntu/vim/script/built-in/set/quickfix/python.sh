#!/bin/bash
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
# File Name: python.sh
# Description: 
#   Generate python error message to test quickfix in vim.
# Edit History: 
#   2012-01-19    File created.
#===============================================================================
echo_error() { echo "$@" >&2 ; } 
echo_error "Traceback (most recent call last):"
echo_error '  File "python.sh", line 27, in <module>'
echo_error '    1/0'
echo_error 'ZeroDivisionError: integer division or modulo by zero'
echo_error "Traceback (most recent call last):"
echo_error '  File "python.sh", line 27, in <module>'
echo_error '    1/0'
echo_error 'ZeroDivisionError: integer division or modulo by zero'
