create stage mydata url='s3://mystage/' connection=(
    ACCESS_KEY_ID='minioadmin',
    SECRET_ACCESS_KEY='minioadmin',
    ENDPOINT_URL='http://192.168.1.100:9900'
);