#! /bin/sh

echo "-------------------------------------------------------"
echo "--- Running benches/def_tests/test.sh               ---"
echo "-------------------------------------------------------"

XEMU=$1
options=$2

$XEMU $options << EOF

EOF

# XEMU and options must be together in quotes
#../genbench.sh "$XEMU $options"  "load_dync(chain),[anc,bench]." "chain_ancestor_bench."
#../genbench.sh "$XEMU $options"  "load_dync(cycle),[anc,bench]." "cycle_ancestor_bench."
../genbench.sh "$XEMU $options"  "load_dync(cycle),[win,bench]." "cycle_win_bench."
../genbench.sh "$XEMU $options"  "load_dync(chain),[win,bench]." "chain_win_bench."
