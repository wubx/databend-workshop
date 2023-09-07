wh="medium-mms5"
host="{租户ID}--${wh}.gw.aliyun-cn-beijing.default.databend.cn"
user="x"
password="x"
port=443
database="x"

export BENDSQL_DSN="databend://${user}:${password}@${host}:${port}/${database}"

options="storage_format = 'native' compression = 'lz4'"
options=""
