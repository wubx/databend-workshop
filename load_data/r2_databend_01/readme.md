# 利用 copy into & user stage 加载数据到 Databend 

## 准备
1. 安装部署 Databend 
2. 下载 ontime 数据
3. 创建 ontime 表
4. 创建帐户
5. 修改 python 脚运行加载数据
6. 测试 SQL

## 安装部署 Databend 
[English Deploying](https://databend.rs/doc/deploy/deploying-databend)

[中文部署](https://mp.weixin.qq.com/s/6lEb0JiwOrzxVGD_Acc10g)

## 下载数据

```
mkdir tsv
cd tsv 
wget https://datasets.databend.rs/t_ontime/ontime_{0..9}{0..9}.tsv.gz
```

## 创建 ontime 表

```
curl https://datasets.databend.rs/t_ontime/create_table.sql | mysql -h 127.0.0.1 -P3307 -uroot 
```

## 创建帐号
```
mysql -h 127.0.0.1 -P3307 -uroot
mysql>create user 'wubx'@'%' idetified by 'wubxwubx';
mysql>grant all privileges on *.* to 'wubx'@'%';
```

## 应程序参考

[local_load.py](./local_load.py)

python3 local_load.py

## 测试 SQL
```
select version();
-- 整体行数统计
SELECT count(*) FROM ontime;
-- 区间数据扫描
SELECT DayOfWeek, count(*) AS c FROM ontime WHERE Year >= 2000 AND Year <= 2008 GROUP BY DayOfWeek ORDER BY c DESC;
select count(*) FROM ontime WHERE Year >= 2000 AND Year <= 2008;
SELECT DayOfWeek, count(*) AS c FROM ontime WHERE DepDelay>10 AND Year >= 2000 AND Year <= 2008 GROUP BY DayOfWeek ORDER BY c DESC;
SELECT Origin, count(*) AS c FROM ontime WHERE DepDelay>10 AND Year >= 2000 AND Year <= 2008 GROUP BY Origin ORDER BY c DESC LIMIT 10;
SELECT IATA_CODE_Reporting_Airline AS Carrier, count() as c FROM ontime WHERE DepDelay>10 AND Year = 2007 GROUP BY Carrier ORDER BY c DESC;
SELECT IATA_CODE_Reporting_Airline AS Carrier, avg(cast(DepDelay>10 as Int8))*1000 AS c3 FROM ontime WHERE Year=2007 GROUP BY Carrier ORDER BY c3 DESC;
SELECT IATA_CODE_Reporting_Airline AS Carrier, avg(cast(DepDelay>10 as Int8))*1000 AS c3 FROM ontime WHERE Year>=2000 AND Year <=2008 GROUP BY Carrier ORDER BY c3 DESC;
SELECT IATA_CODE_Reporting_Airline AS Carrier, avg(DepDelay) * 1000 AS c3 FROM ontime WHERE Year >= 2000 AND Year <= 2008 GROUP BY Carrier;

-- 全表扫
SELECT Year, avg(DepDelay) FROM ontime GROUP BY Year;
SELECT Year, count(*) as c1 FROM ontime GROUP BY Year;
SELECT avg(cnt) FROM (SELECT Year,Month,count(*) AS cnt FROM ontime WHERE DepDel15=1 GROUP BY Year,Month) a;
SELECT avg(c1) FROM (SELECT Year,Month,count(*) AS c1 FROM ontime GROUP BY Year,Month) a;
SELECT OriginCityName, DestCityName, count(*) AS c FROM ontime GROUP BY OriginCityName, DestCityName ORDER BY c DESC LIMIT 10;
SELECT OriginCityName, count(*) AS c FROM ontime GROUP BY OriginCityName ORDER BY c DESC LIMIT 10;
```

