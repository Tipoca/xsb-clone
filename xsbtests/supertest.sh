#! /bin/sh

# $1 must be the path to the XSB installation directory
# This script expects to be run from the testsuite directory

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
./testsuite.sh $xsbdir/bin/xsb

cd $xsbdir/build
echo "Configuring XSB with --enable-local-scheduling"
configure --config-tag=localsched --enable-local-scheduling >> $logfile
echo "Making XSB with --enable-local-scheduling"
makexsb --config-tag=localsched fast >> $logfile
cd $testdir
./testsuite.sh $xsbdir/bin/xsb-localsched

cd $xsbdir/build
echo "Configuring XSB with --enable-chat"
configure --config-tag=chat --enable-chat >> $logfile
echo "Making XSB with --enable-chat"
makexsb --config-tag=chat fast >> $logfile
cd $testdir
./testsuite.sh $xsbdir/bin/xsb-chat


cd $xsbdir/build
echo "Configuring XSB with --enable-chat --enable-local-scheduling"
configure --config-tag=localschedNchat --enable-chat --enable-local-scheduling >> $logfile
echo "Making XSB with --enable-chat --enable-local-scheduling"
makexsb --config-tag=localschedNchat fast >> $logfile
cd $testdir
./testsuite.sh $xsbdir/bin/xsb-localschedNchat

rm $testdir/$lockfile
