#!/bin/sh

cat $1 | grep -e "EDEN" | sed 's/^.*MIN:\s\([0-9]*\).*AVG:\s\([0-9]*\).*MAX:\s\([0-9]*\).*/\1 \2 \3/' | awk 'BEGIN{sum_1=0; sum_2=0; sum_3=0; n=0} {n=n+1; sum_1+=$1; sum_2+=$2; sum_3+=$3} END{print "EDEN => MIN:",sum_1/n,"K  AVG:",sum_2/n,"K  MAX:",sum_3/n,"K"}'
cat $1 | grep -e "FROM" | sed 's/^.*MIN:\s\([0-9]*\).*AVG:\s\([0-9]*\).*MAX:\s\([0-9]*\).*/\1 \2 \3/' | awk 'BEGIN{sum_1=0; sum_2=0; sum_3=0; n=0} {n=n+1; sum_1+=$1; sum_2+=$2; sum_3+=$3} END{print "FROM => MIN:",sum_1/n,"K  AVG:",sum_2/n,"K  MAX:",sum_3/n,"K"}'
cat $1 | grep -e "TO" | sed 's/^.*MIN:\s\([0-9]*\).*AVG:\s\([0-9]*\).*MAX:\s\([0-9]*\).*/\1 \2 \3/' | awk 'BEGIN{sum_1=0; sum_2=0; sum_3=0; n=0} {n=n+1; sum_1+=$1; sum_2+=$2; sum_3+=$3} END{print "TO   => MIN:",sum_1/n,"K  AVG:",sum_2/n,"K  MAX:",sum_3/n,"K"}'
cat $1 | grep -e "OLD" | sed 's/^.*MIN:\s\([0-9]*\).*AVG:\s\([0-9]*\).*MAX:\s\([0-9]*\).*/\1 \2 \3/' | awk 'BEGIN{sum_1=0; sum_2=0; sum_3=0; n=0} {n=n+1; sum_1+=$1; sum_2+=$2; sum_3+=$3} END{print "OLD  => MIN:",sum_1/n,"K  AVG:",sum_2/n,"K  MAX:",sum_3/n,"K"}'

cat $1 | grep -e "ops" | sed 's/\sops\/m//' | awk 'BEGIN{sum=0; n=0} {n+=1; sum+=$1} END{print "SPEED:",sum/n,"ops/m"}'

rm -f $1
