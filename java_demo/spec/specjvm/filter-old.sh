#!/bin/sh

SPACE='object space'

# ${1} should be the name of the directory
COUNT=1
for file in ${1}/scimark*
do
    echo -n ${COUNT}:
    COUNT=$((COUNT+1))
    echo ${file} | sed 's/^.*\///'
    grep ${file} -e "result:.*ops" | sed 's/^.*result:\s//'

    grep ${file} -e "> ${SPACE}" | sed 's/^.*space\s\+\([0-9]\+\)K.*/\1/' \
        | awk '{s+=$1; n+=1} END {print s/n,"K"}'
done
