#! /bin/sh

echo "-------------------------------------------------------"
echo "--- Running cdf_tests/test.sh                     ---"
echo "-------------------------------------------------------"

XEMU=$1
options=$2

# XEMU and options must be together in quotes
#------------------------------------
# Tests of theorem prover
#------------------------------------
../loadtest.sh "$XEMU $options" ce_test "testall."
../loadtest.sh "$XEMU $options" cdftp_test "oneclicktest."
../gentest.sh "$XEMU $options" type0_test "testreturns."
../gentest.sh "$XEMU $options" insert_test "testreturns."
