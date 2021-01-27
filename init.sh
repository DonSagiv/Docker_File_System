#!/bin/bash
/usr/sbin/nmbd -D
/usr/sbin/smbd -D

tail -f /dev/null