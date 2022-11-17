#!/usr/bin/env python3
from databend_py import Client
import os
import io
import requests
import time
from kafka import KafkaConsumer

consumer = KafkaConsumer('s3_topic', bootstrap_servers = '192.168.1.100:9092')

client = Client(
    host='tn3ftqihs--bl.ch.aws-us-east-2.default.databend.com',
    database="default",
    user="cloudapp",
    password="x")

def get_url(file_name):
    sql="presign upload @~/%s"%(file_name)
    _, row = client.execute(sql)
    url = row[0][2]
    return url
    
def upload_file(url,content):
    response=requests.put(url, data=content)
 
def load_file(table_name, file_name):
     copy_sql="copy into %s from @~ files=('%s') file_format=(type='ndjson') purge=true"%(table_name,file_name)
     client.execute(copy_sql)
     
def get_table_num(table_name):
    sql="select count(*) from %s"%(table_name)
    _, row=client.execute(sql)
    print(row[0][0])
    
i=0
c=b''
table_name='orders'
# you can increase this value to increase the throughput
step = 10000
for msg in consumer:
    c = c+msg.value+b'\n'
    i = i + 1
    if i % step == 0 :
       file_name='%d.json'%(i)
       #print(file_name)
       url = get_url(file_name)
       #print(url)
       content = io.BytesIO(c)
       r = upload_file(url,content)
       load_file(table_name,file_name)
       get_table_num(table_name)
       c= b''