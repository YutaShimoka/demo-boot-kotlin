#!/usr/bin/env bash
set -e -o pipefail -o errtrace
err_holder() {
	num="$1"
	echo "[ERROR] Oops, an error occurred. [L${num}]"
	printf '\a'
}
trap 'err_holder $LINENO' ERR

cd "$(dirname "$0")"

echo "[INFO] *****$(basename "$0") START*****"
echo "[INFO] start time: $(date "+%Y/%m/%d %T")"
start_time=$(date +%s)

# Initial Settings

database="db_example"

# Actions

## prior confirmation

if [ -z "$1" ]; then
	echo "[ERROR] no argument specified"
	exit 1
fi

if ! [ "$(mysql --defaults-extra-file=~/my.cnf ${database} -s -N -e "select 'conn'")" ]; then
	echo "[ERROR] connection failed"
	exit 1
fi

## preparation

cd import

## execution

### create table
mysql --defaults-extra-file=~/my.cnf ${database} -e "DROP TABLE IF EXISTS \`book\`;"
mysql --defaults-extra-file=~/my.cnf ${database} -e " \
CREATE TABLE \`book\` ( \
  \`id\` bigint unsigned NOT NULL AUTO_INCREMENT, \
  \`title\` varchar(255) DEFAULT NULL, \
  \`sub_title\` varchar(255) DEFAULT NULL, \
  \`edition\` varchar(255) DEFAULT NULL, \
  \`author\` varchar(255) DEFAULT NULL, \
  \`publisher\` varchar(255) DEFAULT NULL, \
  \`published_date\` char(10) DEFAULT NULL, \
  \`isbn_code\` char(17) DEFAULT NULL, \
  PRIMARY KEY (\`id\`) \
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;"

### change local_infile settings
echo "[INFO][START] change local_infile settings"
local_infile=$(mysql --defaults-extra-file=~/my.cnf ${database} -s -N -e "select @@local_infile;")
if [ "${local_infile}" != "1" ]; then
	mysql --defaults-extra-file=~/my.cnf ${database} -e "SET PERSIST local_infile = 1;"
	echo "[INFO] change local_infile settings ${local_infile} to 1"
else
	echo "[INFO] nothing to do"
fi
echo "[INFO][END] change local_infile settings"

### import data
echo "[INFO][START] import data"
for arg in "$@"; do
	file_name=$arg
	echo "[INFO][START] import ${file_name}"
	mysql --defaults-extra-file=~/my.cnf --local_infile=1 ${database} -e "
	LOAD DATA LOCAL INFILE '${file_name}' INTO TABLE book FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES ( \
		@TITLE, \
		@SUB_TITLE, \
		@EDITION, \
		@AUTHOR, \
		@PUBLISHER, \
		@PUBLISHED_DATE, \
		@ISBN_CODE \
	) \
	SET \
		title = NULLIF(@TITLE, \"-\"), \
		sub_title = NULLIF(@SUB_TITLE, \"-\"), \
		edition = NULLIF(@EDITION, \"-\"), \
		author = NULLIF(@AUTHOR, \"-\"), \
		publisher = NULLIF(@PUBLISHER, \"-\"), \
		published_date = STR_TO_DATE(NULLIF(@PUBLISHED_DATE, \"-\"), '%Y.%m'), \
		isbn_code = NULLIF(@ISBN_CODE, \"-\");"
	echo "[INFO][END] import ${file_name}"
done
echo "[INFO][END] import data"

### rollback local_inline settings
echo "[INFO][START] rollback local_inline settings"
if [ "${local_infile}" != "1" ]; then
	mysql --defaults-extra-file=~/my.cnf ${database} -e "SET PERSIST local_infile = ${local_infile};"
	echo "[INFO] rollback local_inline settings 1 to ${local_infile}"
else
	echo "[INFO] nothing to do"
fi
echo "[INFO][END] rollback local_inline settings"

echo "[INFO] end time: $(date "+%Y/%m/%d %T")"
echo "[INFO] execute time: $(($(date +%s) - "${start_time}")) sec"
echo "[INFO] *****$(basename "$0") END*****"
