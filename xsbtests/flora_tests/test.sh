#! /bin/sh

#============================================================================
echo "-------------------------------------------------------"
echo "--- Running flora_tests/test.sh                       ---"
echo "-------------------------------------------------------"

XEMU=$1
options=$2

file_list=*.flr
flora_options=[flora],flora_shell.
flora_command="chatterbox(off). test."

for file in $file_list ; do
    prog=`basename $file .flr`
    # XEMU and options must be together in quotes
    ../gentest.sh "$XEMU $options -e $flora_options" $prog "$flora_command"
done
