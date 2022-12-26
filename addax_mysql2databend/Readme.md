# 使用 Addax 迁移 MySQL 数据到 Databend 

MySQL 定位在 OLTP 对于大型的 OLAP 分析可以借助于 Databend 实现， 这里面的数据迁移可以借助于：

https://github.com/wgzhao/Addax 

Addax 可以实现全量及增量的迁移(增量有一定的限制，需要有时间字段，需要对数据有较强的控制能力)

## 表结构迁移
可以参考： g_mysql.py 脚本，使用方法：
```
#python3 g_mysql.py -H MySQL_IP -P MySQL_PORT -u MySQL_User -p mysql_password -d dbname |mysql -h databend_ip -Pdatabend_port -udatabend_user dbname

python3 g_mysql.py -H 172.21.16.9 -P 3306 -u root -p vgypH8nc -d wubx |mysql -h 127.0.0.1 -P3307 -uroot wubx
```

## 全量1对1迁移
表名不变，一对一迁移

```
pre_tb="sbtest"
for t in `seq 1 10`
do
	tb=$pre_tb$t
	echo $tb
	./bin/addax.sh ./job/mysql2databend.json -p "-Dsrc_table=$tb"
done
```

## 分库分表的表合并到一起

```
pre_tb="sbtest"
dst_tb="sbtest"
for t in `seq 1 10`
do
	tb=$pre_tb$t
	echo $tb
	./bin/addax.sh ./job/my2databend.json -p "-Dsrc_table=$tb -Ddst_table=$dst_tb"
done
```

## 帮助
阅读： https://wgzhao.github.io/Addax/4.0.11/writer/databendwriter/

这个方法适用于： clickhouse ,posgresql, ... 的数据到 Databend 中。