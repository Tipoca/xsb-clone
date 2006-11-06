#! /bin/sh

XEMU=$1
FILE=$2
NUM=$3
OPT=$4

echo "-------------------------------------------------------"
echo "--- Running benches/tab_benches/mttest.sh           ---"
echo "-------------------------------------------------------"

# XEMU and options must be together in quotes
 ../genbench.sh "$XEMU"  "[prod_cons]." \
		"mt_bench([prod_cons],2000000,$NUM)." "$FILE"
 ../genbench.sh "$XEMU $OPT"  "[trans_clos],readGraph(g256x128)." \
		"mt_benches(g256x128,256,$NUM)." "$FILE"
 ../genbench.sh "$XEMU $OPT"  "[trans_clos],readGraph(g512x64)." \
		"mt_benches(g512x64,512,$NUM)." "$FILE"
 ../genbench.sh "$XEMU $OPT"  "[trans_clos],readGraph(g1024x64)." \
		"mt_benches(g1024x64,1024,$NUM)." "$FILE"
