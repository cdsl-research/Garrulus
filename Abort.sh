function abort () {
watch=(-e CREATE -e CLOSE_WRITE -m)
inotifywait ${watch[@]} /home/futa/newkanshi | while read notice
do
if [ "`echo $notice | awk "{print \$2;}" | grep CREATE`" ]
then
    echo "バックアップ中断"
    killall -SIGSTOP rsync
else
    echo "バックアップ再開"
    killall -SIGCONT rsync
fi
done
}

abort &