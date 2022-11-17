# demo-boot-kotlin

## はじめに

[Spring Boot](http://projects.spring.io/spring-boot/) / [Kotlin](https://kotlinlang.org/) を元にしたサンプル実装のデモンストレーションです。  

## 事前にインストールするもの

* JDK 11
* MySQL 8.0
* Git Bash
* jq

## 前提条件

* my.cnfの作成
* application-local.ymlの作成

<details><summary>Click to expand</summary><br>

### my.cnfの作成

**事前確認**

```bash
$ ls -1 ~/my.cnf
## ls: cannot access '/c/Users/5h1m0kayu02/my.cnf': No such file or directory
```

> ※ my.cnfが作成済みでないこと。

**my.cnfの作成**

```bash
$ cat <<EOF >~/my.cnf
[client]
host=localhost
port=3306
user=root
password=pa\$\$w0rd # 任意のパスワード
EOF
```

**事後確認**

```bash
$ cat ~/my.cnf
## [client]
## host=localhost
## port=3306
## user=root
## password=pa$$w0rd # 任意のパスワード

$ mysql --defaults-extra-file=~/my.cnf -s -N -e "select '接続に成功しました。'" 2>/dev/null || echo "接続に失敗しました。"
## 接続に成功しました。
```

### application-local.ymlの作成

**事前確認**

```bash
$ cd demo-boot-kotlin

$ ls -1 src/main/resources/application-local.yml
## ls: cannot access 'src/main/resources/application-local.yml': No such file or directory
```

> ※ application-local.ymlが作成済みでないこと。

**application-local.ymlの作成**

```bash
$ cat <<EOF >src/main/resources/application-local.yml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/db_example
    username: root
    password: pa\$\$w0rd # 任意のパスワード
    driver-class-name: com.mysql.cj.jdbc.Driver
  config:
    activate:
      on-profile: local
EOF
```

**事後確認**

```bash
$ cat src/main/resources/application-local.yml
## spring:
##   datasource:
##     url: jdbc:mysql://localhost:3306/db_example
##     username: root
##     password: pa$$w0rd # 任意のパスワード
##     driver-class-name: com.mysql.cj.jdbc.Driver
##   config:
##     activate:
##       on-profile: local
```

</details>

## サーバ起動

```bash
$ sh demo-boot-kotlin/tools/deploy.sh jm2020_渡部昇一.tsv jm2021_渡部昇一.tsv
```

## 動作確認

```bash
$ curl -Ss http://localhost:8080/api/book/books | jq
## [
##   {
##     "id": 12,
##     "title": "わが体験的キリスト教論",
##     "sub_title": "ドイツ留学で実感した西洋社会の本質",
##     "edition": null,
##     "author": "渡部昇一 著",
##     "publisher": "ビジネス社",
##     "published_date": "2021.11",
##     "isbn_code": "978-4-8284-2342-5"
##   },
##   {
##     "id": 11,
##     "title": "歪められた昭和史",
##     "sub_title": null,
##     "edition": null,
##     "author": "渡部昇一 著",
##     "publisher": "ワック",
##     "published_date": "2021.10",
##     "isbn_code": "978-4-89831-854-6"
##   },
##   {
##     "id": 10,
##     "title": "昭和史の真実",
##     "sub_title": null,
##     "edition": null,
##     "author": "渡部昇一 著",
##     "publisher": "PHP研究所",
##     "published_date": "2021.06",
##     "isbn_code": "978-4-569-90138-1"
##   },
##   {
##     "id": 9,
##     "title": "渡部昇一の昭和史. 正",
##     "sub_title": null,
##     "edition": "新装版",
##     "author": "渡部昇一 著",
##     "publisher": "ワック",
##     "published_date": "2021.04",
##     "isbn_code": "978-4-89831-838-6"
##   },
##   {
##     "id": 8,
##     "title": "幸福なる人生ウォレス伝",
##     "sub_title": "渡部昇一遺稿",
##     "edition": null,
##     "author": "渡部昇一 著",
##     "publisher": "育鵬社",
##     "published_date": "2020.12",
##     "isbn_code": "978-4-594-08487-5"
##   },
##   {
##     "id": 6,
##     "title": "決定版・日本史",
##     "sub_title": null,
##     "edition": "増補.",
##     "author": "渡部昇一 著",
##     "publisher": "育鵬社 ; 扶桑社 (発売)",
##     "published_date": "2020.10",
##     "isbn_code": "978-4-594-08614-5"
##   },
##   {
##     "id": 5,
##     "title": "「時代」を見抜く力",
##     "sub_title": "渡部昇一的思考で現代を斬る",
##     "edition": null,
##     "author": "渡部昇一 著",
##     "publisher": "育鵬社 ; 扶桑社 (発売)",
##     "published_date": "2020.09",
##     "isbn_code": "978-4-594-08583-4"
##   },
##   {
##     "id": 4,
##     "title": "アングロ・サクソン文明落穂集. 10",
##     "sub_title": null,
##     "edition": null,
##     "author": "渡部昇一 著",
##     "publisher": "広瀬書院 ; 丸善出版 (発売)",
##     "published_date": "2020.08",
##     "isbn_code": "978-4-906701-17-9"
##   },
##   {
##     "id": 3,
##     "title": "語源でひもとく西洋思想史 = Etymology and Philosophy",
##     "sub_title": null,
##     "edition": null,
##     "author": "渡部昇一 著",
##     "publisher": "海竜社",
##     "published_date": "2020.07",
##     "isbn_code": "978-4-7593-1724-4"
##   },
##   {
##     "id": 2,
##     "title": "年表で読む日本近現代史",
##     "sub_title": null,
##     "edition": "増補決定版.",
##     "author": "渡部昇一 著",
##     "publisher": "海竜社",
##     "published_date": "2020.05",
##     "isbn_code": "978-4-7593-1714-5"
##   },
##   {
##     "id": 1,
##     "title": "これだけは知っておきたいほんとうの昭和史",
##     "sub_title": null,
##     "edition": null,
##     "author": "渡部昇一 著",
##     "publisher": "致知出版社",
##     "published_date": "2020.03",
##     "isbn_code": "978-4-8009-1228-2"
##   }
## ]
```
