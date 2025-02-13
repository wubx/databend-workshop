#!/usr/bin/env bash

CURDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
. "$CURDIR"/env.sh

QUERY_DIR="queries"

for i in {1..99}
do
    if [ $i -lt 10 ]
    then
        sql="0$i.sql"
    else
        sql="$i.sql"
    fi

    echo "Run $sql start."
    cat "$QUERY_DIR"/"$sql" | $MYSQL_CLIENT_CONNECT
    echo "Run $sql done."
done