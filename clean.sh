#!/bin/sh
set -e									# Exit immediately if a function doesn't succeed
echo "clean.sh start"
 
make -C ./kernel/ -I/home/Alex/os/ clean
make -C ./lib/libc/ -I/home/Alex/os/ clean