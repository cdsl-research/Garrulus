dirname=ディレクトリ名
echo "指定ディレクトリ:"$dirname
filesize=$(ls -lh $dirname | awk '{sum+=$5} END {print sum}')
echo "合計ファイルサイズ"$filesize"GB"
tlimit=バックアップ期限
echo "後"$(($tlimit / 60))"分"
limit_value=$(($filesize * 1024 / $tlimit))"MB/s"

function limit () {
watch=(-e CREATE -e CLOSE_WRITE -m)
inotifywait ${watch[@]} 監視ディレクトリ | while read notice
do
if [ "`echo $notice | awk "{print \$2;}" | grep CREATE`" ]
then
    echo "帯域幅上限変更"
    killall -SIGSTOP rsync
    expect -c "
      spawn rsync -avhP --bwlimit=$limit_value ファイル名 user@IPアドレス:~/
      echo $limit_value
      expect \"password:\"
      send -- \"パスワード\r\"
      expect eof
      exit
    "
else
    echo "バックアップ再開"
    killall -SIGSTOP rsync
    expect -c "
      spawn rsync -avhP ファイル名 user@IPアドレス:~/
      echo $limit_value
      expect \"password:\"
      send -- \"パスワード\r\"
      expect eof
      exit
    "
fi
done
}

limit &
