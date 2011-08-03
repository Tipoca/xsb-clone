#! /bin/sh

echo "-------------------------------------------------------"
echo "--- Running table_tests/test.sh                     ---"
echo "-------------------------------------------------------"

XEMU=$1
options=$2

#========================================================================
# Force some files to be compiled before running the tests.  cycle.P
# will always be compiled, because there was a bug on Linux in compiling
# this file and we want to catch it.  Since this step is performed only
# so that the corresponding object files exist, it is not included as part
# of the garbage collection test.

$XEMU -m 4000 -c 4000 -g none << EOF

compile(lists).
compile(sets).
compile(correct).
compile(utils).
compile(cycle).

EOF
#========================================================================

#--------------------------------------------------
# Tests get_calls and get_returns and tries as code
#--------------------------------------------------
    # XEMU and options must be together in quotes
../gentest.sh "$XEMU $options" concomp "t, d1, d2."
#--------------------------------------------------
../gentest.sh "$XEMU $options" testdyntable "test."
#--------------------------------------------------
../gentest.sh "$XEMU -l $options" aggregs_test "test."
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
../gentest.sh "$XEMU $options" empty_answer "test".
#------------------------------------------------- atp/atc basic
../gentest.sh "$XEMU $options" abol_test "test".
#------------------------------------------------- a module t basic
../gentest.sh "$XEMU $options" abol_test2 "test".
#------------------------------------------------- a module t gc diff preds
../gentest.sh "$XEMU $options" abol_test2a "test".
#------------------------------------------------- atp gc same preds
../gentest.sh "$XEMU $options" abol_test3 "test".
#------------------------------------------------- atp gc diff preds
../gentest.sh "$XEMU $options" abol_test3a "test".
#------------------------------------------------- atp gc diff preds + valid
../gentest.sh "$XEMU $options" abol_test3b "test".
#------------------------------------------------- atp gc diff preds + valid + multiple gcs
../gentest.sh "$XEMU $options" abol_test3c "test".
#-------------------------------------------------
../gentest.sh "$XEMU $options" atc_test "test".
#------------------------------------------------- cascading abolish for subgoals with gc etc.
../gentest.sh "$XEMU $options" abolish_cascade "test". 
#------------------------------------------------- cascading abolish for preds with gc etc.
../gentest.sh "$XEMU $options" abolish_cascade "test". 
#-------------------------------------------------
../gentest.sh "$XEMU $options" recursive_aboltest "test".
#------------------------------------------------- 
../gentest.sh "$XEMU $options" flora1 "test".
#-------------------------------------------------
../gentest.sh "$XEMU $options" pps "test".
#-------------------------------------------------
../gentest.sh "$XEMU $options" dipti "test".
#-------------------------------------------------
../gentest.sh "$XEMU $options" terrys_trie_test "test".
#-------------------------------------------------
../gentest.sh "$XEMU $options" test_trie_property "test".
#-------------------------------------------------
../gentest.sh "$XEMU $options" bulk_trie_test "test".
#-------------------------------------------------
../gentest.sh "$XEMU $options" test_intern_seq "test".
#------------------------------------------------- tests dynamic tables
../gentest.sh "$XEMU $options" test_dynamic "test".
#-------------------------------------------------
../gentest.sh "$XEMU -l $options" aggregs_test_2 "test."
#--------------------------------------------------
../gentest.sh "$XEMU -l $options" test_just "test."
#--------------------------------------------------
../gentest.sh "$XEMU -l $options" test_calldepth "test."
#--------------------------------------------------
../gentest.sh "$XEMU -l $options" test_answerdepth "test."
#--------------------------------------------------
../gentest.sh "$XEMU -l $options" get_resid "test."
#--------------------------------------------------
../gentest.sh "$XEMU -l $options" test_trievars "test."
#--------------------------------------------------
../gentest.sh "$XEMU -l $options" test_table_dump "test."
#--------------------------------------------------
