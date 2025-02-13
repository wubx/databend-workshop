#!/usr/bin/env bash

CURDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
. "$CURDIR"/env.sh

# Create Database
echo "CREATE DATABASE IF NOT EXISTS ${DATABASE}" | bendsql

tables=(
    call_center   
    catalog_returns  
    customer_address  
    customer_demographics  
    household_demographics  
    inventory  
    promotion  
    ship_mode  
    store_returns  
    time_dim   
    web_page     
    web_sales
    catalog_page  
    catalog_sales    
    customer          
    date_dim               
    income_band             
    item       
    reason     
    store      
    store_sales    
    warehouse  
    web_returns  
    web_site
)

# Clear Data
for t in ${tables[@]}
do
    echo "DROP TABLE IF EXISTS $t ALL" | bendsql
done

# Create Tables;
cat ./tpcds.sql | bendsql

# Load Data
for t in ${tables[@]}
do
    echo "$t"
    insert_sql="copy into  $DATABASE.$t  from @mydata/tpcds1000/ pattern='.*${t}_[\d+].*[.]gz' file_format = (type = CSV compression=auto field_delimiter = '|' record_delimiter = '\n')"
    echo $insert_sql
    echo $insert_sql | bendsql --time
    echo "analyze table $DATABASE.$t;" | bendsql --time
done


