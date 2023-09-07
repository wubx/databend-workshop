# Databend 的 TPCH 测试

## 适用范围
本文档适用于 Databend & Databend Cloud 的 TPCH 压测

## 基础依赖
其中比较重要的一个文件是 **env.sh**
```
# Databend Cloud 使用的 WareHouse
wh="medium-mms5" 

# 云平台的连接串，对应的 {租户}--{WH}.固定的 DNS ，如果是本地环境填 IP 即可
host="租户ID--${wh}.gw.aliyun-cn-beijing.default.databend.cn"  

# 用户名
user="x"

# 密码
password="xxx"

# 端口号，私有化环境默认是: 8000
port=443

# 数据库名
database="tpch_30"

export BENDSQL_DSN="databend://${user}:${password}@${host}:${port}/${database}"

options="storage_format = 'native' compression = 'lz4'"
options=""
```
以上内容根据实际情况更改。 
云平台的连接也可以参考这里：https://docs.databend.cn/getting-started/clients/bendsql

### 安装依赖软件
- duckdb 用于产生 tpch 数据
  ```
  pip install duckdb
  
  ```

- bendsql 连接 Databend 的原生客户端
  建议从 https://github.com/datafuselabs/bendsql  下载最新版本
  关于 bendsql 也可以参考上面的 Readme 使用

- 对应平台的对象存储工具

### 创建外部 Stage
stage 是 Databend 用于管理对象存储上文件的一个方式
建议阅读： https://databend.rs/doc/sql-commands/ddl/stage/ddl-create-stage
例如创建一个指向阿里云北京区的 oss://wubx-bj01/data/ 的 Stage
```
create stage mystage url='s3://wubx-bj01/data/'
connection=(
        ENDPOINT_URL = 'https://oss-cn-beijing-internal.aliyuncs.com'
        ACCESS_KEY_ID = 'x'
        SECRET_ACCESS_KEY = 'x'
);
list @mystage
```
这里可以用于 upload 产生的 TPCH 数据

### 加载数据
1. 产生 tpch-100-sf 的数据，这里有 parquet + zstd 压缩，大概需要 25G 空间

```
python3 gen_data.py 100 
```
生成的数据可以利用平台工具 upload 到 stage 下面
2. 创表结构结构
参考 create_tb.sh

3. 加载数据
根据 load.sh 进行修改

## 压测

参考：
./run.sh 
