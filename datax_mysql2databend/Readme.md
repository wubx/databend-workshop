# 使用 datax 迁移 MySQL 数据到 Databend 

MySQL 定位在 OLTP 对于大型的 OLAP 分析可以借助于 Databend 实现

## 表结构迁移
可以参考： g_mysql.py 脚本，使用方法：
```
#python3 g_mysql.py -H MySQL_IP -P MySQL_PORT -u MySQL_User -p mysql_password -d dbname |mysql -h databend_ip -Pdatabend_port -udatabend_user dbname

python3 g_mysql.py -H 172.21.16.9 -P 3306 -u root -p vgypH8nc -d wubx |mysql -h 127.0.0.1 -P3307 -uroot wubx
```

##  datax jobs 参考
- mysql2databend.json
  

## 帮助
- https://github.com/alibaba/DataX