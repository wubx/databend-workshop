
# 从 kafka 加载数据到 Databend Cloud

kafka 是优化的消息队列，本篇文章用于指导一下如何从 kafka 获取数据存储到 Databend Cloud 中。 

[Databend Cloud](https://app.databend.com)

前提条件：
1. Databend 中创建结构
2. 获取 Databend Cloud 平台帐号及对应 warehouse 连接串
3. 安装 Python databend-py
4. 开发应用开发

## Databend 中创建结构
假设目标表结构为：
```
create table orders(
ordertime UInt64,
orderid  UInt64,
itemid varchar,
orderunits float,
address json
);
```
 进云平台: 左则 *Worksheets* -> *New Worksheet*

![](img/1.png)

创建完表结构。
Databend Cloud Warehouse 连接串获取
可以在登录 Databend Cloud 后台后，点击 Connect 按钮得到连接信息：

![](img/2.png)

点击 Reset DB password 生成密码，记录到安全的地方

![](img/3.png)

从上面获得连接串信息：
```
    host='tn3ftqihs--bl.ch.aws-us-east-2.default.databend.com',
    database="default",
    user="cloudapp",
   #替换为实际的密码
    password="x" 
```

安装 databend-py 
[databend-py](https://github.com/databendcloud/databend-py) 是为 Databend  Protocol 设计的 Python SQL driver，实现了标准的 SQL Interface ，可以帮助用户方便地连接到 databend cloud 上对数据进行操作。

```
pip install databend-py==0.1.6
pip install kafka-python
```
利用连接串信做简单测试:
```
from databend_py import Client
client = Client(
    host='tn3ftqihs--bl.ch.aws-us-east-2.default.databend.com',
    database="default",
    user="cloudapp",
    password="x")
print(client.execute("SELECT 1"))
```
确保运行无报错。 看到输出 1  即可。

## 开发应用开发
### 数据写入
程序逻辑如下
1. 连接 kakfa 这块需要安装 kafka-python  依赖
> Kafka 信息：
Topic: s3_topic
bootstrap_servers: 192.168.1.100:9092

如果是集群模式的 kafka 可以用逗号间隔写多个地址
2. 连接 Databend Cloud 中 warehouse
3. 从 kafka 获取数据
4. 获取 Presign URL
5.  上传文件
6. 调用 copy into 加载文件

[Demo](./kafka_load.py)

对应的测试数据程序demo:
```
 ./bin/ksql-datagen quickstart=orders format=json  topic=s3_topic maxInterval=10
```

Topic 中写入的数据格式参考：

![](img/4.png)

更多支持格式可以参考：https://databend.rs/doc/load-data/

### 数据查询

```
#!/usr/bin/env python3
from databend_py import Client

client = Client(
    host='tn3ftqihs--bl.ch.aws-us-east-2.default.databend.com',
    database="default",
    user="cloudapp",
    password="x")

sql="select * from orders limit 1"
_, row = client.execute(sql)
print(row)
```

## 参考
- Databend pesign: https://databend.rs/doc/reference/sql/ddl/presign/presign
- Load data use copy into: https://databend.rs/doc/reference/sql/dml/dml-copy-into-table
- databend-py https://github.com/databendcloud/databend-py
- Load data: https://databend.rs/doc/load-data/
