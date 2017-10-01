#!/bin/sh
echo "build.sh start"
set -e														# Exit immediately if a function doesn't succeed

#the order you build in is important
#include os root folder for config.mk
make -C ./lib/libc/ -I/home/Alex/os/
make -C ./kernel/ -I/home/Alex/os/
