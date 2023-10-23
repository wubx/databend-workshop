#!/usr/bin/python3
# coding:utf-8
import pymysql
import argparse

def create():
    ap = argparse.ArgumentParser()
    ap.add_argument('-H', '--host', required=False, help="数据库host地址 默认为本机地址", default='localhost')
    ap.add_argument('-P', '--port', required=False, help="数据库端口 默认为3306", default=3306)
    ap.add_argument('-u', '--user', required=True, help="数据库用户名")
    ap.add_argument('-p', '--password', required=True, help="数据库密码")
    ap.add_argument('-d', '--dbname', required=True, help="数据库名称")
    args = vars(ap.parse_args())
    host = args.get('host')
    port = int(args.get('port'))
    user = args.get('user')
    password = args.get('password')
    dbname = args.get('dbname')

    # 连接数据库
    conn = pymysql.connect(host=host, port=port, user=user, password=password)

    cursor = conn.cursor()
    tb_list = '''
    select table_name,table_comment from information_schema.tables where table_schema='{}'
    '''.format(dbname)

    cursor.execute(tb_list)
    tables = cursor.fetchall()

    for tb in tables:
        t = tb[0]
        print("drop table if exists %s;"%(t))
        t_str_sql='''
        select COLUMN_NAME, COLUMN_TYPE,IS_NULLABLE, COLUMN_DEFAULT, COLUMN_COMMENT from information_schema.COLUMNS where table_schema='{0}' and table_name='{1}' order by ORDINAL_POSITION;
        '''.format(dbname,t)
        cursor.execute(t_str_sql)
        t_cols = cursor.fetchall()
        sql="create table if not exists {0}(\n".format(t)
        i = 0
        for c in t_cols:
            if c[2]=="NO":
                sql += "{} {} {}".format(c[0], c[1] ,"NOT NULL")
            else:
                sql += "{} {}".format(c[0], c[1])
            if c[3]!=None:
                sql += " DEFAULT '{}'".format(c[3])

            i = i+1
            if i < len(t_cols):
                sql +=",\n"
            else:
                sql +="\n);"
                print(sql)


if __name__ == '__main__':
    create()