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
## $Id: testall.sh,v 1.3 1999-01-14 20:57:07 kifer Exp $
## 
##


echo "-------------------------------------------------------"
echo "--- Running testall.sh                              ---"
echo "-------------------------------------------------------"


XEMU=$1

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


# float_tests  omitted??? - mk
dirlist="basic_tests prolog_tests retract_tests \
	 table_tests ptq neg_tests sem_tests delay_tests \
	 wfs_tests ai_tests"

for dir in $dirlist ; do
  cd $dir
  if test -f core ; then
     rm -f core
  fi
  ./test.sh "$XEMU"
  cd ..
done
   
rm -f $lockfile
