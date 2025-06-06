#!/bin/sh

ssh "$1" "if [ -d /etc/ssh ]; then echo 'SSH directory exists'; else echo 'SSH directory does not exist'; fi"