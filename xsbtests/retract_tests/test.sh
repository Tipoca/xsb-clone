#! /bin/sh

echo "-------------------------------------------------------"
echo "--- Running retract_tests/test.sh                   ---"
echo "-------------------------------------------------------"

XEMU=$1
options=$2


#---------------------------------------
# Assert and retract tests.
#---------------------------------------
    # XEMU and options must be together in quotes
../gentest.sh "$XEMU $options" testretract "test."
#---------------------------------------
../gentest.sh "$XEMU $options" boyer_assert "boyer."
#---------------------------------------
