# 20250304-Databend-query-spill-settings

为了更好的控制 Databend 的 Query 内存使用，Databend 在

> [feat(query): support query level spill setting by zhang2014 · Pull Request #17542 · databendlabs/databend · GitHub](https://github.com/databendlabs/databend/pull/17542)

这个 PR 后引入了基于 Query 级别的内存控制

- max_query_memory_usage  单个 Query 可以使用到的内存，单位 byte ，目前默认状态是 0 ， 单个 query 使用的最大内存还是受到： max_server_memory_usage 控制。 该参数另外也可以说是控制一个 query 在集群中每个成员节点上分配的最大内存。

- query_out_of_memory_behavior  单个 Query 超过定义的内存大小时的行为，目前支持两个行为：
  
  - throw  对外抛出 soft oom 不会进程退出
  
  - spilling 对 SQL 进行占用内存开始 Spill 出去

在启用 max_query_memory_usage 后 ，query 的最大内存使用会被限制在 max_query_memory_usage 内。



目前 Databend 并发控制由 config 中 max_running_queries  控制，可以结并发和系统任务来决定是否允许超载运行。 



## 该功能上线后影响

该功能上线后以下 settings 失效：

-  join_spilling_bytes_threshold_per_proc

- aggregate_spilling_bytes_threshold_per_proc

- window_partition_spilling_bytes_threshold_per_proc

- sort_spilling_bytes_threshold_per_proc

后续这块逐步完善后原来的：

- max_server_memory_usage 及对应的 Spill 参数也会被取消掉。


