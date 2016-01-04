#! /bin/bash

#jvm_workload=(compiler.compiler compiler.sunflow compress crypto.aes crypto.rsa crypto.signverify derby mpegaudio scimark.fft.large scimark.lu.large scimark.sor.large scimark.sparse.large scimark.fft.small scimark.lu.small scimark.sor.small scimark.sparse.small scimark.monte_carlo serial sunflow xml.transform)
jvm_workload=(compress scimark.fft.large scimark.sparse.small)

function run_workload
{
	GC="-XX:+Use$1"

	mkdir -p collect-$1
	
	for l in "${jvm_workload[@]}";
	do
		cmd="java -jar ${GC} SPECjvm2008.jar  --parseJvmArgs -i 1 -peak -Dspecjvm.benchmark.threads=4 -ctf false -chf false -ikv -wt 20 -it 240 $l"
		echo $cmd 
		cat /sys/kernel/mm/transparent_hugepage/enabled > ./collect-$1/${l}_$2
		$cmd >> ./collect-$1/${l}_$2 &

		sudo perf stat -p `pgrep java` -e LLC-loads -e LLC-load-misses 2> ./collect-$1/perf_${l}_${2} &

		gc_cmd="jstat -gcutil `pgrep java` 3s"
		echo $gc_cmd
		$gc_cmd > ./collect-$1/gc_${l}_${2}

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
	else
		echo "Hugepage OFF"
		sudo sh -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
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
for i in `seq 1 3`;
do
	echo "iteration: $i"
	run_workload G1GC hoff_gon_$i
	run_workload ConcMarkSweepGC hoff_gon_$i
	run_workload ParallelGC hoff_gon_$i
done

hugepage on
for i in `seq 1 3`; 
do
	echo "iteration: $i"
	run_workload G1GC hon_gon_$i
	run_workload ConcMarkSweepGC hon_gon_$i
	run_workload ParallelGC hon_gon_$i
done

