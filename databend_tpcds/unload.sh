#!/usr/bin/env bash

CURDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
. "$CURDIR"/env.sh


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

# Load Data
for t in ${tables[@]}
do
    echo "$t"
    unload_sql="copy into 'fs://$CURDIR/data/$t/' from $DATABASE.$t FILE_FORMAT = (type = CSV)"
    echo $unload_sql | $MYSQL_CLIENT_CONNECT
    #cp $CURDIR/data/$t/data*.csv $CURDIR/data/$t.csv
    #rm -rf $CURDIR/data/$t/
done


