#!/usr/bin/env bash
source ./env.sh

gen_copy_sql(){
    #echo "copy into ${t} from @tpch_data/tpch100_single_gz/${t}.tbl.gz file_format=(type=csv field_delimiter='|' compression=auto)" | bendsql
    echo "copy into ${t} from @tpch_data/${database}/${t}/ pattern='.*[.]parquet' file_format=(type=parquet)" 
    echo "copy into ${t} from @tpch_data/${database}/${t}/ pattern='.*[.]parquet' file_format=(type=parquet)" | bendsql
    echo "analyze table ${t}" | bendsql

}
for t in customer lineitem nation orders partsupp part region supplier; do
    echo ${t}
    start=$(date +%s)
    gen_copy_sql
    end=$(date +%s)
    use_sec=$(( end - start ))
    echo "load ${t} use: ${use_sec} sec"
done

