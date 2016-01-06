#!/bin/sh

if [ $# = 0 ]; then
    ALG="ParallelGC"
    LOG=""
elif [ $# = 1 ]; then
    if [ $1 = 'p' ]; then
        ALG="ParallelGC"
    elif [ $1 = 'g' ]; then
        ALG="G1GC"
    fi
    LOG=""
elif [ $# = 2 ]; then
    if [ $1 = 'p' ]; then
        ALG="ParallelGC"
    elif [$1 = 'g' ]; then
        ALG="G1GC"
    fi
    if [ $2 = 'y' ]; then
        LOG="-XX:+PrintGCDetails"
    else
        LOG=""
    fi
fi

java -XX:+Use${ALG} ${LOG} -Xbootclasspath/p:lib/javac.jar -jar SPECjvm2008.jar -ikv -wt 5s -it 5s -bt 4 compress
