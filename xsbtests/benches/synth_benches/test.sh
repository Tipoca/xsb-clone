#! /bin/sh

XEMU=$1
options=$2

echo "-------------------------------------------------------"
echo "--- Running benches/synth_benches/test.sh           ---"
echo "-------------------------------------------------------"

# XEMU and options must be together in quotes
 ../genbench.sh "$XEMU $options"  "[chain],[anc,bench]." "chain_ancestor_bench."
 ../genbench.sh "$XEMU $options"  "[cycle],[anc,bench]." "cycle_ancestor_bench."
#../genbench.sh "$XEMU $options"  "[cycle],[win,bench]." "cycle_win_bench."
#../genbench.sh "$XEMU $options"  "[chain],[win,bench]." "chain_win_bench."



