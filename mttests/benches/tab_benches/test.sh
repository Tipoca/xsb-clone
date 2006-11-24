#! /bin/sh

XEMU=$1
FILE=$2

echo "-------------------------------------------------------"
echo "--- Running benches/tab_benches/test.sh             ---"
echo "-------------------------------------------------------"

# XEMU and options must be together in quotes
 ../genbench.sh "$XEMU"  "[cs_o]." "bench([cs_o],100)." "$FILE"
 ../genbench.sh "$XEMU"  "[cs_r]." "bench([cs_r],50)." "$FILE"
 ../genbench.sh "$XEMU"  "[disj]." "bench([disj],200)." "$FILE"
 ../genbench.sh "$XEMU"  "[gabriel]." "bench([gabriel],140)." "$FILE"
 ../genbench.sh "$XEMU"  "[kalah]." "bench([kalah],150)." "$FILE"
 ../genbench.sh "$XEMU"  "[peep]." "bench([peep],50)." "$FILE"
 ../genbench.sh "$XEMU"  "[pg]." "bench([pg],200)." "$FILE"



