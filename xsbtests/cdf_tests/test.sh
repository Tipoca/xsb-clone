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
../gentest.sh "$XEMU $options" type0QueryExt "testreturns."
../gentest.sh "$XEMU $options" type0QueryInt "testreturns."
../gentest.sh "$XEMU $options" dlQuery "testreturns."
../gentest.sh "$XEMU $options" updateExt "testreturns."
../gentest.sh "$XEMU $options" updateInt "testreturns."
../gentest.sh "$XEMU $options" updateDL "testreturns."
