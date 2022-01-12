#!/bin/bash
currentDir=`dirname $0`
filename="$currentDir/sites.txt"
sites=""
while read line; do
#reading each line
sites+="${line} "
done < $filename

mkcert -key-file $currentDir/../web/nginx/ssl/_wildcard-key.pem -cert-file $currentDir/../web/nginx/ssl/_wildcard.pem $sites
