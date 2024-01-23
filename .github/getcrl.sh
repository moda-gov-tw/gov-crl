#!/bin/bash
#取得廢止清冊
wget https://moica.nat.gov.tw/repository/MOICA/CRL2/complete.crl

#取得卡號
openssl crl -nameopt utf8 -inform DER -text -in complete.crl | grep "Serial Number" | cut -d " " -f 7 > temp
awk -v RS= '/----/{next}{gsub(/\n/,"\",\"")}BEGIN{printf "\""}7' temp > temp2
SN="$(cat temp2)\""

#取得版本號
version=$(openssl crl -nameopt utf8 -inform DER -text -in complete.crl | awk '/X509v3 CRL Number:/ {getline; gsub(/^[ \(/^[ \t]+|[ \t]+$/, ""); print}')
printf "{\"version\":\"$version\", \"value\":[$SN]}" > moica-crl.json
#上次執行時間
date '+%Y-%m-%d %H:%M.%S' > .github/last_executed.txt

rm temp temp2 complete.crl
