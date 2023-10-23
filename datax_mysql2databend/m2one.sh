pre_tb="sbtest"
dst_tb="sbtest"
for t in `seq 1 10`
do
	tb=$pre_tb$t
	echo $tb
	./bin/addax.sh ./job/my2databend.json -p "-Dsrc_table=$tb -Ddst_table=$dst_tb"
done