#!/bin/bash
# Takes DOI strings as arguments for wget to first get SchHub info page, then extract pdf url, and then get that pdf!
# usage:
# Get a single pdf with: ./sciHub.sh 10.1145/1375761.1375762
# USe as many DOIs as arguents as you'd like :)
# to pass a list of DOI strings as arguments to this script you could use: "cat DOIS.txt | xargs ./sciHub.sh"
# replace .se in the sci-hub url with whatever tld is currently in operation....

_OUTPUT_DIR="/mnt/d/Documents/papers"
[ ! -d $_OUTPUT_DIR ] && mkdir -p $_OUTPUT_DIR

for DOI in "$@"; do
    _URL=https:`wget https://sci-hub.se/$DOI -qO - | grep -Eom1 '//[^ ]+\.pdf' ` 
    wget $_URL -P $_OUTPUT_DIR
done
unset DOI _URL _OUTPUT_DIR
