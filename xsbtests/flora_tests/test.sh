#! /bin/sh

#============================================================================
echo "-------------------------------------------------------"
echo "--- Running flora_tests/test.sh                       ---"
echo "-------------------------------------------------------"

XEMU=$1
options=$2

file_list=*.flr

# abp.flr does not work. Perhaps the program is wrong.
# btupdates.flr is loaded using btupdates_load.flr
exclude_list="abp.flr btupdates.flr"

flora_options=flora_shell.
flora_command="chatterbox(off). test. flEnd."

# Test if element is a member of exclude list
# $1 - element
# $2 - exclude list
member ()
{
    for elt in $2 ; do
	if test "$1" = "$elt" ; then
	    return 0
	fi
    done
    return 1
}

OBJEXT=.xwam

# Remove the Prolog and object files to make sure we are using the 
# latest compiled sources
# Precautionary measure: rm  only if we are certain 
# that this is flora_tests directory
dir=`pwd`
dir=`basename $dir`
if test "flora_tests"="$dir" ; then
    rm -f *.P *${OBJEXT} *.fld *.fdb
    rm -f auxiliary/*.P auxiliary/*${OBJEXT} auxiliary/*.fld auxiliary/*.fdb
fi


# run the tests
for file in $file_list ; do
    if member $file "$exclude_list"; then
	continue
    fi
    prog=`basename $file .flr`
    touch $file
    # XEMU and options must be together in quotes
    ../gentest.sh "$XEMU $options -e $flora_options" $prog "$flora_command"
done

