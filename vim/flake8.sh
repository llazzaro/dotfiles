#!/bin/sh
PYMAJOR=$(python --version | awk '{print $2}'| awk -F. '{print $1}')
exec /usr/bin/python$PYMAJOR /usr/bin/flake8 $*
