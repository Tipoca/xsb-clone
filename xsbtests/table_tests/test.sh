#! /bin/sh

echo "-------------------------------------------------------"
echo "--- Running table_tests/test.sh                     ---"
echo "-------------------------------------------------------"

XEMU=$1
options=$2


$XEMU $options << EOF

[lists].

[sets].

[correct].

[utils].

EOF

#--------------------------------------------------
# Tests get_calls and get_returns and tries as code
#--------------------------------------------------
    # XEMU and options must be together in quotes
../gentest.sh "$XEMU $options" concomp "t, d1, d2."
#--------------------------------------------------
../gentest.sh "$XEMU $options" testdyntable "test."
#--------------------------------------------------
../gentest.sh "$XEMU $options" aggregs_test "test."
#--------------------------------------------------
../gentest.sh "$XEMU $options" trassert "test."
#--------------------------------------------------
../gentest.sh "$XEMU $options" trdyntest "test."
#--------------------------------------------------
../gentest.sh "$XEMU $options" trdynctest "test."
#--------------------------------------------------
../gentest.sh "$XEMU $options" ins "test."
#--------------------------------------------------
../gentest.sh "$XEMU $options" float "test."
#-------------------------------------------------
../gentest.sh "$XEMU $options" tabbug1 "test."
#-------------------------------------------------
../gentest.sh "$XEMU $options" expand "test."
#-------------------------------------------------
../gentest.sh "$XEMU $options" internt "test."
#-------------------------------------------------
../gentest.sh "$XEMU $options" grammarlrk3 "test."
#-------------------------------------------------
../gentest.sh "$XEMU $options" lrbug "test."
#-------------------------------------------------
../gentest.sh "$XEMU $options" unw_tr1 "test."
#-------------------------------------------------
../gentest.sh "$XEMU $options" trdyn "test".
#-------------------------------------------------
../gentest.sh "$XEMU $options" tfinda "test".
#-------------------------------------------------
# test heap reclamation after check complete
../gentest.sh "$XEMU $options" testh "time2048."
#-------------------------------------------------
 
echo "--------------------------------------------------------------------"
echo "Testing empty_answer"
$XEMU $options << EOF
[empty_answer].
test.
EOF

