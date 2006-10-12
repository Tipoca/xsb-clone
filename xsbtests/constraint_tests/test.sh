#! /bin/sh

# This directory is intended for tests of Prolog-level constraints as
# well as CHR libraries.  Attribute variable tests per se should be
# in ../attv_tests.

#============================================================================
echo "-------------------------------------------------------"
echo "--- Running constraint_tests/test.sh                ---"
echo "-------------------------------------------------------"

XEMU=$1
opts=$2

../gentest.sh "$XEMU $opts" test_constraintLib "test."
../gentest.sh "$XEMU $opts" timetest "test."
../gentest.sh "$XEMU $opts" gctest "test."
