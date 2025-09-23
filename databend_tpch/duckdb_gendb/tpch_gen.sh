#!/bin/bash

# 配置变量
SF=100
MAX_INDEX=$((SF - 1)) 

D="tpch_${SF}"
S3_ENDPOINT="127.0.0.1:9900"
S3_ACCESS_KEY="minioadmin"
S3_SECRET_KEY="minioadmin"
S3_BUCKET="mydata"

S3_USE_SSL="false"  # 可以是 true 或 false
S3_URL_STYLE="path"  # 可以是 'path' 或 'vhost'


TABLES=("customer" "lineitem" "nation" "orders" "partsupp" "part" "region" "supplier")

# 清理并创建目录
rm -rf "${SF}" "${D}"
mkdir -p "${SF}"

# 创建表目录结构
for t in "${TABLES[@]}"; do
    mkdir -p "${D}/${t}"
done

# 生成并执行SQL文件
for ((i=0; i<=MAX_INDEX; i++)); do
    SQL_FILE="./${SF}/${i}.sql"
    
    # 生成SQL内容
    cat > "${SQL_FILE}" << EOF
LOAD tpch;
SET s3_endpoint='${S3_ENDPOINT}';
SET s3_access_key_id='${S3_ACCESS_KEY}';
SET s3_secret_access_key='${S3_SECRET_KEY}';

SET s3_use_ssl=${S3_USE_SSL};
SET s3_url_style='${S3_URL_STYLE}';

CALL dbgen(sf = ${SF}, children=${SF}, step=${i});

EOF

    # 添加COPY语句
    for t in "${TABLES[@]}"; do
        echo "COPY ${t} TO 's3://${S3_BUCKET}/mystage/${D}/${t}/${i}.parquet' (FORMAT 'parquet', COMPRESSION 'zstd', ROW_GROUP_SIZE 1000000);" >> "${SQL_FILE}"
    done

    echo "Processing step ${i}"
    
    # 执行SQL文件
    if [ -f "$SQL_FILE" ]; then
        duckdb < "$SQL_FILE"
    else
        echo "Error: File not found: $SQL_FILE" >&2
        exit 1
    fi
done

echo "TPC-H data generation completed for SF=${SF}"