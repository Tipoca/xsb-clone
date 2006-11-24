#! /bin/sh

XEMU=$1
FILE=$2

echo "-------------------------------------------------------"
echo "--- Running benches/synth_benches/test1.sh          ---"
echo "-------------------------------------------------------"

# XEMU and options must be together in quotes
 ../genbench.sh "$XEMU"  "load_dyn(chain),[anc1,bench]." "chain_ancestor_bench." "$FILE"
 ../genbench.sh "$XEMU"  "load_dyn(cycle),[anc1,bench]." "cycle_ancestor_bench." "$FILE"
 ../genbench.sh "$XEMU"  "load_dyn(cycle),[win1,bench]." "cycle_win_bench." "$FILE"
 ../genbench.sh "$XEMU"  "load_dyn(chain),[win1,bench]." "chain_win_bench." "$FILE"



