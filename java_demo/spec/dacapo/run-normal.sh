#! /bin/bash

jvm_workload=(jython)
#jvm_workload=(avrora fop h2 jython luindex lusearch pmd sunflow tomcat tradebeans xalan)
#jvm_workload=(avrora batik eclipse fop h2 jython luindex lusearch pmd sunflow tomcat tradebeans tradesoap xalan)
PAR="--size superlarge"

function run_workload
{
	GC="-XX:+Use$1"

	mkdir -p collect-$1

	for l in "${jvm_workload[@]}";
	do
		# clear the cache
		sync
		echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
		NOW=`date +"%H-%M"`

		#cmd="java -jar ${GC} dacapo-9.12-bach.jar $l --no-validation ${PAR}"
		cmd="java -jar ${GC} ./benchmarks/dacapo.jar $l --no-validation ${PAR}"
		echo $cmd 
		cat /sys/kernel/mm/transparent_hugepage/enabled > ./collect-$1/${l}_$2_${NOW}
		$cmd &>> ./collect-$1/${l}_$2_${NOW} &

		sudo perf stat -p `pgrep java` -e cache-references,cache-misses,page-faults,LLC-loads,LLC-load-misses,L1-dcache-loads,L1-dcache-load-misses,L1-icache-loads,L1-icache-load-misses,dTLB-loads,dTLB-load-misses,iTLB-load,iTLB-load-misses 2> ./collect-$1/perf_${l}_${2}_${NOW} &

		gc_cmd="jstat -gcutil `pgrep java` 3s"
		echo $gc_cmd
		$gc_cmd > ./collect-$1/gc_${l}_${2}_${NOW}

		sudo kill -INT `pgrep perf`

		for job in `jobs -p`;
		do
			wait $job
		done
	done
}

function hugepage
{
    if [[ "$1" = "on" ]]; then
	echo "Hugepage ON"
	sudo sh -c "echo always > /sys/kernel/mm/transparent_hugepage/enabled"
    elif [[ "$1" = "off" ]]; then
	echo "Hugepage OFF"
	sudo sh -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
    else
        echo "Hugepage MADVISE"
	sudo sh -c "echo madvise > /sys/kernel/mm/transparent_hugepage/enabled"
    fi
}

control_c()
{
	echo "forcely quit"
	for job in `jobs -p`;
	do
		kill -9 $job
	done
	exit $?
}

trap control_c SIGINT

hugepage off
for i in `seq 1 10`;
do
	echo "iteration: $i"
	#run_workload G1GC hoff_gon_$i
	#run_workload ConcMarkSweepGC hoff_gon_$i
	#run_workload ParNewGC hoff_gon_$i
	run_workload ParallelGC hoff_gon_$i
done

