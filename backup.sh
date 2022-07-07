#!/bin/sh

expect -c "
  set timeout 3
  spawn rsync -av movies futa@futa-backup:~/backup
  expect \"password:\"
  send -- \"#MEZ92tgj\r\"
  expect eof
  exit
"
