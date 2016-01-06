#!/bin/sh

java -XX:+UseParallelGC -Xbootclasspath/p:lib/javac.jar -jar -XX:+PrintGCDetails SPECjvm2008.jar -ikv -wt 5s -it 5s -bt 4 compress
