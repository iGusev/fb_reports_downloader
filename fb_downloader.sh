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
		loopenddate=$(/bin/date +%Y-%m-%d)
		currentdate=$(/bin/date --date "$loopenddate -30 days" +%Y-%m-%d)
		token=$(<tokens/$1)

		until [ "$currentdate" == "$loopenddate" ]
		do
		  	echo $currentdate;
			n="dirty_reports/$1_$currentdate.tar.gz";
		  	curl --silent --output $n "https://paymentreports.facebook.com/$2/report?$token&type=digest&date=$currentdate"

		  	if [ -f "$n" ];
		  		then
		  		unzip -o -d dirty_reports/ $n
				rm $n
			fi
			n="dirty_reports/$1_$currentdate.tar.gz";
		  	curl --silent --output $n "https://paymentreports.facebook.com/$2/report?$token&type=detail&date=$currentdate"

		  	if [ -f "$n" ];
		  		then
		  		unzip -o -d dirty_reports/ $n
				rm $n
			fi
		  	currentdate=$(/bin/date --date "$currentdate 1 day" +%Y-%m-%d)
		done
	fi
done