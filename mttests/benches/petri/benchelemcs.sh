XEMu=$1
MAX=$2

#XEMU=$PREF/bin/xsb-mt
FILE=./elemRes.P

rm -f $FILE

nthreads=1
while [ $nthreads -le $MAX ]
do
echo "-------------------- Testing $nthreads threads ------------------------------"
    ../genbench.sh "$XEMU" "[benchmark_elem], gen_proc_2(500,$MAX)." \
"bench_private_process_cs($nthreads)." "$FILE"

nthreads=$[$nthreads*2]
done

