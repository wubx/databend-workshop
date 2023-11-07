#!/bin/bash
source ./env.sh

TRIES=3
QUERY_NUM=1

N=22
for i in `seq 1 $N`; do
    # [ -z "$HOST" ] && sync
    # [ -z "$HOST" ] && echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null
    
    query=`cat sql/q${i}.sql`
    echo -n "Q${i}: ["
    for i in $(seq 1 $TRIES); do
         RES=$(bendsql --time --query="${query}" --output null 2>&1 ||:)
        [[ "$?" == "0" ]] && echo -n "${RES}" || echo -n "null"
        [[ "$i" != $TRIES ]] && echo -n ", "

        echo "${QUERY_NUM},${i},${RES}" >> result.csv
    done
    echo "],"

    QUERY_NUM=$((QUERY_NUM + 1))
done
