nohup java -cp 'libs/*' aztec.AztecServer >> aztecserver.log 2>&1 &
echo $! > aztecserver.pid
