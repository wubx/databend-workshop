#!/usr/bin/env python3
import pymysql
import os
import requests
import time

path="./tsv"
cnx = pymysql.connect(user='wubx', password='wubxwubx',
                              host='192.168.1.100',
                              port = 3307,
                              database='default')

cursor = cnx.cursor()


copy_sql="copy into ontime from @~ files=('%s') file_format=(type='tsv' compression='auto')"

print("1. Get file lists")
os.chdir(path)
files=os.listdir()
files.sort()

print("2. Upload file lists")
for i in files:
    t1= time.time()
    sql="presign upload @~/%s"%(i)
    cursor.execute(sql)
    url = cursor.fetchone()[2]
    with open(i, 'rb') as f:
        data =f.read()
    response=requests.put(url, data=data)
    t2=time.time()
    print("Upload %s use: %s"%(i, (t2-t1)))

print("3. End upload file lists")


sql="select value from system.settings where name='max_threads'"
cursor.execute(sql)
max_threads=int(cursor.fetchone()[0])
if max_threads >16:
    max_threads=16

print("4. Use copy into load data")
for i in range(0, len(files), max_threads):
    t1=time.time()
    f=files[i:i+max_threads]
    l=','.join("'{0}'".format(x) for x in f)
    copy_sql="copy into ontime from @~ files=(%s) file_format=(type='tsv' compression='auto') purge=true"%(l)
    #print(copy_sql)
    cursor.execute(copy_sql)
    t2=time.time()
    print("Load %s into databend use: %s s"%(l,(t2-t1)))

print("5. End load data")

print("6. count table")
sql="select count(*) from ontime"
cursor.execute(sql)
print("ontime table rows: %d"%(cursor.fetchone()[0]))

cursor.close()
cnx.close()