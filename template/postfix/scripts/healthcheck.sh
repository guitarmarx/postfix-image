#!/bin/bash
set -e

# check saslauthd is running
ps -C saslauthd || exit 1

# check postfix is running
ps -C master ||  exit 1
netstat -plnt | grep ':25' || exit 1

# return 0 if when all checks passed
exit 0