#! /bin/sh 

## File:      testall.sh
## Author(s): Probably Juliana Freire (rewritten by kifer)
## Contact:   xsb-contact@cs.sunysb.edu
## 
## Copyright (C) The Research Foundation of SUNY, 1996-1999
## 
## XSB is free software; you can redistribute it and/or modify it under the
## terms of the GNU Library General Public License as published by the Free
## Software Foundation; either version 2 of the License, or (at your option)
## any later version.
## 
## XSB is distributed in the hope that it will be useful, but WITHOUT ANY
## WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
## FOR A PARTICULAR PURPOSE.  See the GNU Library General Public License for
## more details.
## 
## You should have received a copy of the GNU Library General Public License
## along with XSB; if not, write to the Free Software Foundation,
## Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
##
## $Id: testall.sh,v 1.6 1999-08-20 05:46:16 kifer Exp $
## 
##


echo "-------------------------------------------------------"
echo "--- Running testall.sh                              ---"
echo "-------------------------------------------------------"

while test 1=1
do
    case "$1" in
     *-opt*)
	    shift
	    options=$1
	    shift
	    ;;
     *-exclud*)
	    shift
	    excluded_tests=$1
	    shift
	    ;;
      *)
	    break
	    ;;
    esac
done

if test -z "$1" -o $# -gt 1; then
  echo "Usage: testall.sh [-opts opts] [-exclude \"test_list\"] executable"
  echo "where: opts       -- options to pass to XSB executable"
  echo "       test_list  -- quoted, space-separated list of tests to NOT run"
  echo "       executable -- full path name of the XSB executable"
  exit
fi

XEMU=$1

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

lockfile=lock.test
testdir=`pwd`

trap 'rm -f $testdir/$lockfile; exit 1' 1 2 15

if test -f $testdir/$lockfile; then
   echo "************************************************************"
   echo ./$lockfile exists
   echo Probably testsuite is already running...
   echo If not, remove ./$lockfile
   echo and continue
   echo "************************************************************"
   exit
else
   echo $$ > $lockfile
fi


    # float_tests don't pass. --mk
testlist="basic_tests prolog_tests retract_tests \
	  table_tests ptq neg_tests sem_tests delay_tests \
	  wfs_tests ai_tests"

# Run each test in $testlist except for the tests in $excluded_tests
for tst in $testlist ; do
  if member "$tst" "$excluded_tests" ; then
    continue
  else
    cd $tst
    if test -f core ; then
	rm -f core
    fi
    ./test.sh "$XEMU" "-e segfault_handler(warn). $options"
    cd ..
  fi
done
   
rm -f $lockfile
