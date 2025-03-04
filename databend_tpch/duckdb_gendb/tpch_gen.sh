
sf=1000
d="tpch_${sf}"
mkdir ${sf}
rm ${sf}/
mkdir ${d}

for t in customer lineitem nation orders partsupp part region supplier; do
	mkdir -p ${d}/${t}
done

for i in {0..999}; do
	echo "LOAD tpch;" >${sf}/${i}.sql
	echo "SET s3_endpoint='172.10.10.10:9090';" >> ${sf}/${i}.sql
	echo "SET s3_access_key_id='databend';" >> ${sf}/${i}.sql
	echo "SET s3_secret_access_key='databend';" >> ${sf}/${i}.sql
	echo "SET s3_use_ssl=false;" >> ${sf}/${i}.sql
	echo "SET s3_url_style='path';" >> ${sf}/${i}.sql

	echo "CALL dbgen(sf = ${sf},children=1000,step=${i});">>${sf}/${i}.sql

	for t in customer lineitem nation orders partsupp part region supplier; do
		echo "copy ${t} to 's3://databend/mystage/${d}/${t}/$i.parquet' (FORMAT 'parquet', COMPRESSION 'zstd', ROW_GROUP_SIZE 1000000);">>${sf}/${i}.sql
	done
	echo ${i}

	file="./${sf}/${i}.sql"
	if [ -f "$file" ] ; then
		./duckdb < "$file"
	else
		echo " File not found: $file"
	fi

done
