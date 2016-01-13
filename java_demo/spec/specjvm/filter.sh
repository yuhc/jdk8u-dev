#!/bin/sh

SPACE='eden space'

# ${1} should be the name of the directory
for file in ${1}/scimark*
do
    echo ${file} | sed 's/^.*\///'
    grep ${file} -e "result:.*ops" | sed 's/^.*result:\s//'

    grep ${file} -e "> ${SPACE}" | sed 's/^.*space\s\+\([0-9]\+\)K.*/\1/' \
        | awk '{s+=$1; n+=1} END {print s/n,"K"}'
done
