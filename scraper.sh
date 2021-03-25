#!/bin/bash


#	usage:
#	./scraper.sh -w "website"
#	do not pass "/" symbol as arg in $website
#	eg. instead of "https://app.pickle.finance/" use "app.pickle.finance"

# defaults
website="app.pickle.finance"

OPTIND=1
# Reset in case getopts has been used previously in the shell

while getopts ":w:" arg; 
do 
	case "$arg" in 
	w) website="$OPTARG"
	;;
	esac
done

echo "downloading website: $website"

wget  -r -pk $website


grep -RwoE '0x.{40}' $website | cut -d ":" -f2 | grep -v '["()$"%&= ,]'| awk '!seen[$0]++' > $website.txt

rm -r $website


exit 0
