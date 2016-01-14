#!/bin/sh

SPACE='eden space'
EDEN='eden space'
OLD='object space'

# ${1} should be the name of the directory
COUNT=1
for file in ${1}/derby*
do
    #echo -n ${COUNT}:
    #COUNT=$((COUNT+1))
    #echo ${file} | sed 's/^.*\///'

    grep ${file} -e "result:.*ops" | sed 's/^.*result:\s\(.*\)/\1/'

    grep ${file} -e "> ${EDEN}" | sed 's/^.*space\s\+\([0-9]\+\)K.*/\1/' \
        | awk 'BEGIN{mn=1000000}{if (mn>$1) {mn=$1} if (mx<$1) {mx=$1} s+=$1; n+=1} END {print "EDEN => MIN:",mn,"K"," AVG:",s/n,"K"," MAX:",mx,"K"}'
    grep ${file} -e "> ${OLD}" | sed 's/^.*space\s\+\([0-9]\+\)K.*/\1/' \
        | awk 'BEGIN{mn=1000000}{if (mn>$1) {mn=$1} if (mx<$1) {mx=$1} s+=$1; n+=1} END {print "OLD  => MIN:",mn,"K"," AVG:",s/n,"K"," MAX:",mx,"K"}'
done
