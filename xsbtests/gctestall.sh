#! /bin/sh 

## File:      gctestall.sh
## Author(s): Kostis Sagonas (adapted from testall.sh)
## Contact:   xsb-contact@cs.sunysb.edu
## 
## Copyright (C) K.U. Leuven 1999
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
## $Id: gctestall.sh,v 1.1 1999-02-23 17:54:02 kostis Exp $
## 
##


echo "-------------------------------------------------------"
echo "--- Running gctestall.sh                            ---"
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

# sem_tests probably still cuts over tables and is not to be trusted 100%
# ai_tests should be tested only with sliding garbage collection - not copying

dirlist="basic_tests prolog_tests retract_tests table_tests \
	 ptq neg_tests delay_tests wfs_tests"

for dir in $dirlist ; do
  cd $dir
  if test -f core ; then
     rm -f core
  fi
  ./test.sh "$XEMU"
  cd ..
done
   
rm -f $lockfile
