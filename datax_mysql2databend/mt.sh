pre_tb="sbtest"
for t in `seq 1 10`
do
	tb=$pre_tb$t
	echo $tb
	./bin/addax.sh ./job/mysql2databend.json -p "-Dsrc_table=$tb"
done