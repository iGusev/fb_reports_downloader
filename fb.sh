#!/bin/bash

for filename in accounts/*; do
	echo $filename
	s=$(<$filename)
	set -- $s
	res=$(curl --write-out %{http_code} --silent --output tokens/$1 -F grant_type=client_credentials -F client_id=$2 -F client_secret=$3 https://graph.facebook.com/oauth/access_token)
	if [ $res != "200" ];
	then
		rm tokens/$1
	else
		currentmonth=$(/bin/date +%Y-%m)
		currentdate=$(/bin/date +%Y-%m-01)
		loopenddate=$(/bin/date +%Y-%m-%d)
		token=$(<tokens/$1)
		report="reports/$1_$currentmonth.csv"
		
		rm -rf $report;
		echo "app_id,app_name,payment_type,product_type,recv_currency,recv_amount,fx_batch_id,fx_rate,settle_currency,settle_amount,tax_amount" >> $report

		until [ "$currentdate" == "$loopenddate" ]
		do
		  	echo $currentdate;
			n="dirty_reports/$1_$currentdate.tar.gz";
		  	curl --silent --output $n "https://paymentreports.facebook.com/$2/report?$token&type=digest&date=$currentdate"

		  	if [ -f "$n" ];
		  		then
		  		unzip -o -d dirty_reports/ $n
				rm $n
				start=$(grep -n ',payment_digest$' dirty_reports/$2_digest_$currentdate.csv | cut -d : -f 1);
				cat "dirty_reports/$2_digest_$currentdate.csv" |  cut -d, -f2- | tail -n +$(($start+2)) | head -n -2 >> $report;
			fi
		  	currentdate=$(/bin/date --date "$currentdate 1 day" +%Y-%m-%d)
		done
	fi
done


# start=$(grep -n ',payment_digest$' 131240566933960_digest_2015-02-05.csv | cut -d : -f 1)

# echo $start;