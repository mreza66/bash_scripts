#!/bin/bash
if [ -z "$1" ]
then 
	echo "Please enther domain name"
exit 1
fi
domain_name=$1
shift
new_epoch=`date +%s`
dig +noall +answer "$domain_name" | while read _ _ _ _ ip;
do 
	expiry_date=` echo | openssl s_client -showcerts -servername $domain_name -connect $ip:443 2>/dev/null | openssl x509 -inform pem -noout -enddate | cut -d "=" -f 2 `
	expiry_epoch=`date -d "$expiry_date" +%s`
	expiry_days="$(( ("$expiry_epoch" - "$new_epoch") / ( 3600 * 24 ) ))"
	echo "$expiry_days"
	exit 0
done
