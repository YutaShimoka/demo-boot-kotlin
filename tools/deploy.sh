#!/usr/bin/env bash
set -e -o pipefail -o errtrace
trap 'echo "[INFO] *****$(basename "$0") END*****"' 2
err_holder() {
	num="$1"
	echo "[ERROR] Oops, an error occurred. [L${num}]"
	printf '\a'
}
trap 'err_holder $LINENO' ERR

cd "$(dirname "$0")"

echo "[INFO] *****$(basename "$0") START*****"

# Actions

## preparation

source ./conf/local.conf

## execution

### create database
if [ "$(mysql --defaults-extra-file=~/my.cnf -s -N -e "show databases like '${database}';")" != "${database}" ]; then
	mysql --defaults-extra-file=~/my.cnf -e "create database ${database};"
fi

### create test data
if [ -n "$1" ]; then
	sh create_test_data.sh "$@"
fi

### server start

echo "[INFO] server start"

cd ..

./gradlew bootRun || if [ $? == 130 ]; then true; else false; fi
