#! /bin/sh

echo "-------------------------------------------------------"
echo "--- Running socket_tests/test.sh                     ---"
echo "-------------------------------------------------------"

XEMU=$1
options=$2

    # XEMU and options must be together in quotes
../gentest.sh "$XEMU $options" socket_basics "test."
../gentest.sh "$XEMU $options" socket_timeout "test."
