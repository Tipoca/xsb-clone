#! /bin/sh

XEMU=$1
FILE=$2

echo "-------------------------------------------------------"
echo "--- Running benches/tab_benches/test_s.sh           ---"
echo "-------------------------------------------------------"

# XEMU and options must be together in quotes
 ../genbench.sh "$XEMU"  "[cs_o_s]." "bench([cs_o],25)." "$FILE"
 ../genbench.sh "$XEMU"  "[cs_r_s]." "bench([cs_r],12)." "$FILE"
 ../genbench.sh "$XEMU"  "[disj_s]." "bench([disj],40)." "$FILE"
 ../genbench.sh "$XEMU"  "[gabriel_s]." "bench([gabriel],35)." "$FILE"
 ../genbench.sh "$XEMU"  "[kalah_s]." "bench([kalah],40)." "$FILE"
 ../genbench.sh "$XEMU"  "[peep_s]." "bench([peep],12)." "$FILE"
 ../genbench.sh "$XEMU"  "[pg_s]." "bench([pg],50)." "$FILE"



