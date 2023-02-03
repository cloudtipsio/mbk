#!/bin/bash

# generate ssh keys
/usr/bin/ssh-keygen -A

# run sshd server
/usr/sbin/sshd

# continue execution
exec "$@"
