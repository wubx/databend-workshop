# databend-workshop


## 使用 DataX 迁移 MySQL 数据到 Databend 
-  基本环境 MysQL,  Databend
- 项目地址：[datax_mysql2databend](https://github.com/wubx/databend-workshop/tree/main/datax_mysql2databend)
-  使用到技能：
   - MySQl 表结构到 Databend 转换
   - streaming_load
## 使用 user stage  & copy into 加载文件 2022-11-17
- 基本环境：Databend + MinIO
- 项目： [r2_databend_01](./load_data/r2_databend_01)
- 使用到技能：
   - MySQL 协议连接 Databend
   - Presign 使用
   - copy into 的并行调用
   - 基本 SQL 调用

## 从 kafka 中加载数据到 Databend Cloud 2022-11-17
- 基本环境：Databend Cloud on AWS
- 项目： [databend_cloud](./load_data/databend_cloud)
- 使用到技能：
  - Databend Cloud python Driver 安装
  - kafka 中数据获取
  - Presign 使用
  - copy into 调用
  - 基本 SQL 调用
  
## 持续高效的写入 Databend

- todo 