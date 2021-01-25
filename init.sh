#!/bin/bash
sleep 5

/usr/sbin/nmbd -D
/usr/sbin/smdb -D

tail -f /dev/null