#! /bin/sh

XEMU=$1
FILE=$2

echo "-------------------------------------------------------"
echo "--- Running benches/synth_benches/test_seq.sh       ---"
echo "-------------------------------------------------------"

# XEMU and options must be together in quotes
 ../genbench.sh "$XEMU"  "[trans_clos],readGraph(g256x128)."\
			 "seq_benches(g256x128,256)." "$FILE"
 ../genbench.sh "$XEMU"  "[trans_clos],readGraph(g512x64)."\
			 "seq_benches(g512x64,512)." "$FILE"
 ../genbench.sh "$XEMU"  "[trans_clos],readGraph(g1024x64)."\
			 "seq_benches(g1024x64,1024)." "$FILE"



