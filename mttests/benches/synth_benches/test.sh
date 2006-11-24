#! /bin/sh

XEMU=$1
FILE=$2

echo "-------------------------------------------------------"
echo "--- Running benches/synth_benches/test.sh           ---"
echo "-------------------------------------------------------"

# XEMU and options must be together in quotes
 ../genbench.sh "$XEMU"  "load_dyn(chain),[anc,bench]." "chain_ancestor_bench." "$FILE"
 ../genbench.sh "$XEMU"  "load_dyn(cycle),[anc,bench]." "cycle_ancestor_bench." "$FILE"
 ../genbench.sh "$XEMU"  "load_dyn(cycle),[win,bench]." "cycle_win_bench." "$FILE"
 ../genbench.sh "$XEMU"  "load_dyn(chain),[win,bench]." "chain_win_bench." "$FILE"



