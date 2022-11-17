# 利用 copy into & user stage 加载数据到 Databend 

## 准备
1. 安装部署 Databend 
2. 下载 ontime 数据
3. 创建 ontime 表
4. 创建帐户
5. 修改 python 脚运行加载数据

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
curl https://datasets.databend.rs/create_table.sql | mysql -h 127.0.0.1 -P3307 -uroot 
```

## 创建帐号
```
mysql -h 127.0.0.1 -P3307 -uroot
mysql>create user 'wubx'@'%' idetified by 'wubxwubx';
mysql>grant all privileges on *.* to 'wubx'@'%';
```

## 应程序参考

[local_load](./local_load.py)

python3 local_load.py
