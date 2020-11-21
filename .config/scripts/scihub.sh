#!/bin/bash
# Takes DOI strings as arguments for wget to first get SchHub info page, then extract pdf url, and then get that pdf!
# usage:
# Get a single pdf with: ./sciHub.sh 10.1145/1375761.1375762
# USe as many DOIs as arguents as you'd like :)
# to pass a list of DOI strings as arguments to this script you could use: "cat DOIS.txt | xargs ./sciHub.sh"
# replace .tw in the sci-hub url with whatever tld is currently in operation....

for DOI in "$@"; do
    wget https://sci-hub.tw/$DOI -qO - | grep -Eom1 'https://[^ ]+\.pdf' | wget -i -
done
unset DOI
