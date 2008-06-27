PREF=$1
MAX=$2

XEMU=$PREF/bin/xsb-mt
FILE=./wfRes.P

rm -f $FILE

nthreads=1
while [ $nthreads -le $MAX ]
do

echo "-------------------- Testing $nthreads threads ------------------------------"

	../genbench.sh "$XEMU" "[benchmark_wf], gen_private_wf." \
			"private_scale_wf($nthreads)." "$FILE"

	../genbench.sh "$XEMU" "[benchmark_wf], gen_shared_wf." \
			"shared_bench_wf($nthreads)." "$FILE"


	nthreads=$[$nthreads*2]
done

