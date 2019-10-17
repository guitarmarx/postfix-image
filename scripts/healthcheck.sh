#!/bin/bash
set -e

# check saslauthd is running (if saslauthd is enabled)
if ! [ -z "$IMAP_HOST" ]; then
    ps -C saslauthd || exit 1
fi

ps -C saslauthd || exit 1

# check postfix is running
ps -C master ||  exit 1
netstat -plnt | grep ':25' || exit 1

# return 0 if when all checks passed
exit 0