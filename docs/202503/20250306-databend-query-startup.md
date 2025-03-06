# Databend-query 启动脚本注意事项



## 二制制启动

参考 databend-query 启动相关的参数

```
#cat scripts/q.sh 
echo "Stop old Databend instances"
kill -9 `pidof databend-query`
pkill tail
echo "Deploy new Databend(standalone)"
ulimit -n 65535
export _DATABEND_INTERNAL_MAX_CONURRENT_IO_REQUEST=300
export _DATABEND_INTERNAL_RETRY_IO_TIMEOUT=10
# export STORAGE_S3_ENABLE_VIRTUAL_HOST_STYLE=true
nohup bin/databend-query --config-file=configs/databend-query.toml 2>&1 >>query.log &
sleep 3
tail -f query.log &

```



- ulimit -n 65535 修改进程可以打开的文件句柄

- _DATABEND_INTERNAL_MAX_CONURRENT_IO_REQUEST=300  私有化和国内对象存储的 IO 并发控制，这里设置成 300 ，可以根据实际情况调整。调大有利性能，但对象存储顶不住时会有抖动

- _DATABEND_INTERNAL_RETRY_IO_TIMEOUT=10  声明 IO 超时时间，对于对象存储如果有长尾的情况下，可以通过这个参数让 10 秒内没回来请求的连接断开重新请求，通过重试的方式消掉长尾。

## Docker 的 Query 启动

生产环境建议分别启动 databend-meta, databend-query  在国内可以使用 Databend Cloud 提供的 docker 源：

> registry.databend.cn/public/databend-meta:nightly
> 
> registry.databend.cn/public/databend-query:nightly

### databend-meta

``` 
docker run --name databend-meta    \
      --privileged \
      --network=host \
      -v /home/vagrant/meta:/var/lib/databend/meta \
      -v /data/databend/log:/var/log/databend \
      -v /etc/databend:/etc/databend \
      -e METASRV_CONFIG_FILE='/etc/databend/databend-meta.toml' \
      -d registry.databend.cn/public/databend-meta:nightly
```

### databend-query

```
docker stop databend3307
docker rm databend3307
docker run --name databend3307    \
      --privileged \
      --network=host \
      -v /etc/databend:/etc/databend \
      -v /etc/localtime:/etc/localtime \
      -v /data/databend/3307:/var/log/databend \
      -v /data/databend/3307disk:/var/lib/databend \
      -e CONFIG_FILE="/etc/databend/databend-query-3307.toml" \
      -e _DATABEND_INTERNAL_MAX_CONURRENT_IO_REQUEST=300 \
      -e _DATABEND_INTERNAL_RETRY_IO_TIMEOUT=10 \
      -d registry.databend.cn/public/databend-query:nightly



```


