#! /bin/sh

echo "-------------------------------------------------------"
echo "--- Running benches/xmc/test.sh                     ---"
echo "-------------------------------------------------------"

XEMU=$1
options=$2


# XEMU and options must be together in quotes
../genbench.sh "$XEMU $options"  "[main]." "bench_leader."
../genbench.sh "$XEMU $options"  "[main]." "bench_sieve."
