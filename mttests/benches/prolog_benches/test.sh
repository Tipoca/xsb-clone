#! /bin/sh

XEMU=$1
FILE=$2

echo "-------------------------------------------------------"
echo "--- Running benches/prolog_benches/test.sh          ---"
echo "$XEMU $2"
echo "-------------------------------------------------------"

# XEMU and options must be together in quotes
../genbench.sh "$XEMU"  "[deriv]." "bench_deriv([deriv],300,1000)." "$FILE"
../genbench.sh "$XEMU"  "[nreverse]." "bench_nrev([nrev],150,600)."  "$FILE"
../genbench.sh "$XEMU -m 4096"  "[qsort]." "bench_qsort([qsort],10,1000)." "$FILE"
../genbench.sh "$XEMU"  "[serial]." "bench_serialise([serialise],40,3000)." "$FILE"
../genbench.sh "$XEMU "  "[query]." "bench_query([query],1500)." "$FILE"
../genbench.sh "$XEMU "  "[tak]." "bench_tak([tak],1)." "$FILE"
../genbench.sh "$XEMU "  "[compiler]." "bench_compiler([compiler])." "$FILE"
