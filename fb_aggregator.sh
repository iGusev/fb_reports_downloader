#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
for filename in $DIR/accounts/*; do
	echo $filename
	s=$(<$filename)
	set -- $s

	name=$1
	clientid=$2

	set `date +%m" "%Y`
	CURMTH=$1
	CURYR=$2

	if [ $CURMTH -eq 1 ]
	then PRVMTH=12
	     PRVYR=`expr $CURYR - 1`
	else PRVMTH=`expr $CURMTH - 1`
	     PRVYR=$CURYR
	fi

	if [ $PRVMTH -lt 10 ]
	then PRVMTH="0"$PRVMTH
	fi

	currentdate=$PRVYR-$PRVMTH-01
	loopenddate=$(/bin/date +%Y-%m-%d)
	CURRPRT="$DIR/reports/${name}_digest_$CURYR-$CURMTH.csv"
	PRVRPRT="$DIR/reports/${name}_digest_$PRVYR-$PRVMTH.csv"
	

	for report in $CURRPRT $PRVRPRT; do
		rm -rf $report;
		echo "date,app_id,app_name,payment_type,product_type,recv_currency,recv_amount,fx_batch_id,fx_rate,settle_currency,settle_amount,tax_amount" > $report;
	done

	until [ "$currentdate" == "$loopenddate" ]
	do
	  	echo $currentdate;
	  	currentyear=$(/bin/date --date "$currentdate" +%Y)
	  	currentmonth=$(/bin/date --date "$currentdate" +%m)
		n="$DIR/dirty_reports/${clientid}_digest_$currentdate.csv";

	  	if [ -f "$n" ];
	  		then
			start=$(grep -n ',payment_digest$' $DIR/dirty_reports/${clientid}_digest_$currentdate.csv | cut -d : -f 1);
			cat "$DIR/dirty_reports/${clientid}_digest_$currentdate.csv" |  cut -d, -f2- | tail -n +$(($start+2)) | head -n -2 | sed -e "s/^/$currentdate,/" >> "$DIR/reports/${name}_digest_${currentyear}-${currentmonth}.csv";
		fi
	  	currentdate=$(/bin/date --date "$currentdate 1 day" +%Y-%m-%d)
	done
done