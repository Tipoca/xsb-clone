#! /bin/sh

XEMU=$1
FILE=$2

echo "-------------------------------------------------------"
echo "--- Running benches/tab_benches/test.sh             ---"
echo "-------------------------------------------------------"

# XEMU and options must be together in quotes
 ../genbench.sh "$XEMU"  "[cs_o]." "bench([cs_o],25)." "$FILE"
 ../genbench.sh "$XEMU"  "[cs_r]." "bench([cs_r],12)." "$FILE"
 ../genbench.sh "$XEMU"  "[disj]." "bench([disj],40)." "$FILE"
 ../genbench.sh "$XEMU"  "[gabriel]." "bench([gabriel],35)." "$FILE"
 ../genbench.sh "$XEMU"  "[kalah]." "bench([kalah],40)." "$FILE"
 ../genbench.sh "$XEMU"  "[peep]." "bench([peep],12)." "$FILE"
 ../genbench.sh "$XEMU"  "[pg]." "bench([pg],50)." "$FILE"



