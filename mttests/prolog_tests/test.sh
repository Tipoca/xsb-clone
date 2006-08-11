#! /bin/sh

echo "-------------------------------------------------------"
echo "--- Running prolog_tests/test.sh                    ---"
echo "-------------------------------------------------------"

XEMU=$1
NUM=$2
options=$3

#------------------------------------
# tests involving WAM execution
#------------------------------------
# XEMU and options must be together in quotes
# convention is that to use test_single, leave the last argument of test
# goal uninstantiated to unify with the stream.

../gentest.sh "$XEMU $options" deriv "test_deriv(100,_)" $NUM
../gentest.sh "$XEMU $options" nreverse "test_nrev(10,500,_)" $NUM
../gentest.sh "$XEMU $options" query "test_query(1000,_)" $NUM
../gentest.sh "$XEMU $options" qsort "test_qsort(10,1000,_)" $NUM

# the test below uses the C interface and cannot currently be tested

#../gentest.sh "$XEMU $options" serialise "test_serialise(40,_)" $NUM

../seqgentest.sh "$XEMU $options" mutex_test "test." 