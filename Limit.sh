function limit () {
watch=(-e CREATE -e CLOSE_WRITE -m)
inotifywait ${watch[@]} /home/futa/newkanshi | while read notice
do
if [ "`echo $notice | awk "{print \$2;}" | grep CREATE`" ]
then
    echo "バックアップ制限"
    #limit_command
else
    echo "バックアップ制限解除"
    #rsync
fi
done
}

limit &
