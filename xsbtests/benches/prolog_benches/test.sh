#! /bin/sh

XEMU=$1
options=$2

echo "-------------------------------------------------------"
echo "--- Running benches/prolog_benches/test.sh           ---"
echo "$XEMU $2"
echo "-------------------------------------------------------"

# XEMU and options must be together in quotes
../genbench.sh "$XEMU $options"  "[deriv]." "bench_deriv([deriv],100,500)."
../genbench.sh "$XEMU $options"  "[nreverse]." "bench_nrev([nrev],50,300)."
../genbench.sh "$XEMU $options"  "[qsort]." "bench_qsort([qsort],1,1000)."
../genbench.sh "$XEMU $options"  "[serialise]." "bench_serialise([serialise],100,10000)."
../genbench.sh "$XEMU $options"  "[query]." "bench_query([query],500)."
../genbench.sh "$XEMU $options"  "[tak]." "bench_ak([ak],1)."
