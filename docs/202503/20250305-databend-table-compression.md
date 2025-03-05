# Databend 表级压缩选择

## 基本使用

Databend 默认采用 zstd 压缩算法，同时也可以选择： lz4 压缩算法。



```
create table t01 (id int) compression=lz4;
```

默认是 zstd

```
create table t02 (id int);
```

表使用的哪种压缩查看

```
set hide_options_in_show_create_table=0;
show create table t01;
show create table t02;
```

更改默认压缩行为，需要更改配置文件： 

```
[query]
default_compression='lz4'
```

批量把 zstd 表转成 lz4 表

```
create table lineitem_lz4 compression='lz4' as select * from lineitem;
insert into lineitem_lz4 select * from lineitem;
```

# 
