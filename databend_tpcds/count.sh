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

# Clear Data
for t in ${tables[@]}
do
        echo "select count(*) from $t"
        echo "select count(*) from $t" | bendsql
done