#!/usr/bin/python3
import duckdb
import pathlib
import sys

if sys.argv[1]:
    sf = int(sys.argv[1])
else:
    sf = 1

for x in range(0, sf) :
    con=duckdb.connect()
    con.sql('PRAGMA disable_progress_bar;SET preserve_insertion_order=false')
    con.sql(f"CALL dbgen(sf={sf} , children ={sf}, step = {x})")
    for tbl in ['nation','region','customer','supplier','lineitem','orders','partsupp','part'] :
        num=con.query(f"select count(*) from {tbl}").fetchone()[0]
        if num > 0:
            pathlib.Path(f'./tpch_{sf}/{tbl}').mkdir(parents=True, exist_ok=True)
            con.sql(f"COPY (SELECT * FROM {tbl}) TO './tpch_{sf}/{tbl}/{x}.parquet' (FORMAT 'parquet', COMPRESSION 'zstd', ROW_GROUP_SIZE 1000000);")
    con.close()