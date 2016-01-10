#!/bin/sh

if [ $# = 0 ]; then
    ALG="ParallelGC"
    LOG=""
elif [ $# = 1 ]; then
    if [ $1 = 'p' ]; then
        ALG="ParallelGC"
    elif [ $1 = 'g' ]; then
        ALG="G1GC"
    elif [ $1 = 'n' ]; then
        ALG="ParNewGC"
    fi
    LOG=""
elif [ $# = 2 ]; then
    if [ $1 = 'p' ]; then
        ALG="ParallelGC"
    elif [ $1 = 'g' ]; then
        ALG="G1GC"
    elif [ $1 = 'n' ]; then
        ALG="ParNewGC"
    fi
    if [ $2 = 'y' ]; then
        LOG="-XX:+PrintGCDetails"
    else
        LOG=""
    fi
fi

#transparent hugepage
sudo bash -c "echo madvise > /sys/kernel/mm/transparent_hugepage/enabled"
sudo bash -c "echo 10 > \
    /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs"
sudo bash -c "echo 60 > \
    /sys/kernel/mm/transparent_hugepage/khugepaged/alloc_sleep_millisecs"

java -XX:+Use${ALG} ${LOG} -Xbootclasspath/p:lib/javac.jar -jar SPECjvm2008.jar -ikv -wt 5s -it 5s -bt 4 compress

#recover
sudo bash -c "echo always > /sys/kernel/mm/transparent_hugepage/enabled"
sudo bash -c "echo 10000 > \
    /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs"
sudo bash -c "echo 60000 > \
    /sys/kernel/mm/transparent_hugepage/khugepaged/alloc_sleep_millisecs"

