#! /bin/sh

## File:      supertest.sh
## Author(s): Michael Kifer
## Contact:   xsb-contact@cs.sunysb.edu
## 
## Copyright (C) The Research Foundation of SUNY, 1999
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
## $Id: supertest.sh,v 1.7 1999-02-28 01:14:08 kifer Exp $
## 
##

# THIS SCRIPT EXPECTS TO BE RUN FROM THE TESTSUITE DIRECTORY

# $1 must be the path to the XSB installation directory

xsbdir=$1
testdir=`pwd`
logfile=/tmp/xsb_super_log.`whoami`
lockfile=lock.super

if test -z "$xsbdir" ; then
   echo "Arg 1 must be a path to the XSB installation directory"
   exit 1
elif test ! -d "$xsbdir" ; then
   echo "$xsbdir: XSB root directory doesn't exist or has wrong permissions"
   exit 1
fi

# Make sure to delete locks, if the user decides to abort the test
trap 'rm -fr $testdir/$lockfile $testdir/lock.test; exit 1' 1 2 15

if test -f "$testdir/$lockfile" ; then
 echo "./$lockfile exists. Remove it first"
 exit
else
 echo $$ > $lockfile
fi

cd $xsbdir/build
echo "Configuring XSB with default options"
configure > $logfile
echo "Making XSB with default options"
makexsb fast >> $logfile
cd $testdir
./testsuite.sh $xsbdir

cd $xsbdir/build
echo "Configuring XSB with --enable-local-scheduling"
configure --config-tag=localsched --enable-local-scheduling >> $logfile
echo "Making XSB with --enable-local-scheduling"
makexsb --config-tag=localsched fast >> $logfile
cd $testdir
./testsuite.sh -tag localsched $xsbdir

cd $xsbdir/build
echo "Configuring XSB with --enable-chat"
configure --config-tag=chat --enable-chat >> $logfile
echo "Making XSB with --enable-chat"
makexsb --config-tag=chat fast >> $logfile
cd $testdir
./testsuite.sh -tag chat $xsbdir


cd $xsbdir/build
echo "Configuring XSB with --enable-chat --enable-local-scheduling"
configure --config-tag=localschedNchat --enable-chat --enable-local-scheduling >> $logfile
echo "Making XSB with --enable-chat --enable-local-scheduling"
makexsb --config-tag=localschedNchat fast >> $logfile
cd $testdir
./testsuite.sh -tag localschedNchat $xsbdir

rm $testdir/$lockfile
