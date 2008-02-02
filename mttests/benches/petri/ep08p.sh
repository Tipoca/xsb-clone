PREF=$1
DIR=$2
MAX=$3

XEMU=$PREF/bin/xsb-mt
FILE=$DIR/petri.P


../genbench.sh "$XEMU" "[benchmark_elem]." "bench_2($MAX)." "$FILE"

../genbench.sh "$XEMU" "[benchmark_wf]." "bench_2($MAX)." "$FILE"
