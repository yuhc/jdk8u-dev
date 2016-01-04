#!/bin/sh

java -Xbootclasspath/p:lib/javac.jar -jar -XX:+PrintGCDetails SPECjvm2008.jar -wt 5s -it 5s -bt 2 compress
