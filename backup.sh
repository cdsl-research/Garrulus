#!/bin/sh

expect -c "
  set timeout 3
  spawn rsync -av movies [user]@[host-name]:~/backup
  expect \"password:\"
  send -- \"[password]\r\"
  expect eof
  exit
"
