#!/bin/bash

benchmark=(avrora fop h2 jython luindex lusearch pmd sunflow tomcat tradebeans xalan)

for l in "${benchmark[@]}";
do
    echo -n "$l: "
    grep "PASS" $1/${l}* | sed -e 's/^.*PASSED\sin\s\([0-9]\+\)\s.*/\1/' | awk 'BEGIN{sum=0; n=0} {sum+=$1; n+=1} END{print sum/n,"msec"}'
done

