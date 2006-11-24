#! /bin/sh

XEMU=$1
FILE=$2
NUM=$3

echo "-------------------------------------------------------"
echo "--- Running benches/tab_benches/mttest.sh           ---"
echo "-------------------------------------------------------"

# XEMU and options must be together in quotes
 ../genbench.sh "$XEMU"  "[cs_o]." "mt_bench([cs_o],100,$NUM)." "$FILE"
 ../genbench.sh "$XEMU"  "[cs_r]." "mt_bench([cs_r],50,$NUM)." "$FILE"
 ../genbench.sh "$XEMU"  "[disj]." "mt_bench([disj],200,$NUM)." "$FILE"
 ../genbench.sh "$XEMU"  "[gabriel]." "mt_bench([gabriel],140,$NUM)." "$FILE"
 ../genbench.sh "$XEMU"  "[kalah]." "mt_bench([kalah],150,$NUM)." "$FILE"
 ../genbench.sh "$XEMU"  "[peep]." "mt_bench([peep],50,$NUM)." "$FILE"
 ../genbench.sh "$XEMU"  "[pg]." "mt_bench([pg],200,$NUM)." "$FILE"

