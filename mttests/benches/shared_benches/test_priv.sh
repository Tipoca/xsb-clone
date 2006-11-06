#! /bin/sh

XEMU=$1
FILE=$2

echo "-------------------------------------------------------"
echo "--- Running benches/synth_benches/test_priv.sh      ---"
echo "-------------------------------------------------------"

# XEMU and options must be together in quotes
 ../genbench.sh "$XEMU"  "[trans_clos],readGraph(g256x128)."\
			 "priv_benches(g256x128,256)." "$FILE"
 ../genbench.sh "$XEMU"  "[trans_clos],readGraph(g512x64)."\
			 "priv_benches(g512x64,512)." "$FILE"
 ../genbench.sh "$XEMU"  "[trans_clos],readGraph(g1024x64)."\
			 "priv_benches(g1024x64,1024)." "$FILE"



