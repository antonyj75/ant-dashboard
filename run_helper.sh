#!/bin/bash -ex
#####################################################################
# Purpose : Run the dashing thin server

#####################################################################
# Independent Variables
export PATH=$PATH:/home/jesudhas/code/node-v4.1.1-linux-x64/bin

#####################################################################
# Dependent Variables


#####################################################################
# Code
bundle
dashing start
