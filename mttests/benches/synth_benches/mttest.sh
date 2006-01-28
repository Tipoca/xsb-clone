#! /bin/sh

XEMU=$1
FILE=$2
NUM=$3

echo "-------------------------------------------------------"
echo "--- Running benches/synth_benches/mttest.sh         ---"
echo "-------------------------------------------------------"

# XEMU and options must be together in quotes
 ../genbench.sh "$XEMU"  "[chain],[anc,bench]." "mt_chain_ancestor_bench($NUM)." "$FILE"
 ../genbench.sh "$XEMU"  "[cycle],[anc,bench]." "mt_cycle_ancestor_bench($NUM)." "$FILE"
 ../genbench.sh "$XEMU"  "[cycle],[win,bench]." "mt_cycle_win_bench($NUM)." "$FILE"
 ../genbench.sh "$XEMU"  "[chain],[win,bench]." "mt_chain_win_bench($NUM)." "$FILE"



