# TPC-DS for Databend

**=======THIS REPO IS ARCHIVED=======**

The contents of this repo have been moved to https://github.com/datafuselabs/databend/tree/main/benchmark/tpcds

**=======THIS REPO IS ARCHIVED=======**

## Data and queries generation

Use DuckDB to generate data and queries.

### Get Data

```
shell> duckdb tpcds.db

duckdb> INSTALL tpcds;
duckdb> LOAD tpcds;
duckdb> SELECT * FROM dsdgen(sf=0.01);
duckdb> EXPORT DATABASE '/tmp/tpcds_0_01/' (FORMAT CSV, DELIMITER '|');

shell> mv /tmp/tpcds_0_01/ "$(pwd)/data/"
```

### Get Queries

- https://github.com/duckdb/duckdb/tree/master/extension/tpcds/dsdgen/queries

## Load data into Databend

Run the script `load.sh`.

```shell
chmod +x load.sh
./load.sh
```

## Run query SQLs

Run the script `run.sh`.

```shell
chmod +x run.sh
./run.sh
```
