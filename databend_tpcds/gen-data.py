#!/usr/bin/python3
import duckdb
import pathlib
import sys

if sys.argv[1]:
sf = int(sys.argv[1])
        else:
        sf = 1

con=duckdb.connect()
        con.sql('PRAGMA disable_progress_bar;SET preserve_insertion_order=false')
        con.sql(f"CALL dsdgen(sf={sf}")
        for tbl in ['call_center','catalog_page','catalog_returns','catalog_sales','customer','customer_address','customer_demographics','date_dim','household_demographics','income_band','inventory','item','promotion','reason','ship_mode','store','store_returns','store_sales','time_dim','warehouse','web_page','web_returns','web_sales','web_site'] :
        num=con.query(f"select count(*) from {tbl}").fetchone()[0]
        if num > 0:
        pathlib.Path(f'./tpcds_{sf}/{tbl}').mkdir(parents=True, exist_ok=True)
        con.sql(f"COPY (SELECT * FROM {tbl}) TO './tpcds_{sf}/{tbl}/{x}.parquet' (FORMAT 'parquet', COMPRESSION 'zstd', ROW_GROUP_SIZE 1000000);")

con.close()

