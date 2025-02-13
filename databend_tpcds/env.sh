#!/usr/bin/env bash
export DATABASE=tpcds1000
export BENDSQL_DSN="databend://databend:@127.0.0.1:8000/tpcds1000?sslmode=disable"
export BENDSQL_CLIENT_CONNECT="bendsql --time"

