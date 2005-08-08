#! /bin/sh

XEMU=$1
NUM=$2
options=$3

echo "-------------------------------------------------------"
echo "--- Running assert_tests/test.sh w. $NUM threads    ---"
echo "-------------------------------------------------------"

#------------------------------------
# tests involving assert
#------------------------------------
# XEMU and options must be together in quotes
# convention is that to use test_single, leave the last argument of test
# goal uninstantiated to unify with the stream.

../gentest.sh "$XEMU $options" assert_noindex "test_assert(1000,_)" $NUM

../gentest.sh "$XEMU $options" call_dyna "test_call_dyna(1000,_)" $NUM

../gentest.sh "$XEMU $options" assert_wo "test_assert_wo(1000,_)" $NUM
../gentest.sh "$XEMU $options" assert_wo1 "test_assert_wo1(1000,_)" $NUM

../gentest.sh "$XEMU $options" assert_writethenread "test_assert_writethenread(1000,_)" $NUM

../gentest.sh "$XEMU $options" assert_wr "test_assert_wr(1000,_)" $NUM
../gentest.sh "$XEMU $options" assert_wr1 "test_assert_wr1(1000,_)" $NUM

../gentest.sh "$XEMU $options" assert_rw "test_assert_rw(1000,_)" $NUM
../gentest.sh "$XEMU $options" assert_rw1 "test_assert_rw1(1000,_)" $NUM

../gentest.sh "$XEMU $options" assert_retpri "test_retract(40000,_)" $NUM
