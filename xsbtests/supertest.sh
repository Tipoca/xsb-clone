#! /bin/sh

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

config=`$xsbdir/build/config.guess`
canonical=`$xsbdir/build/config.sub $config`
execdir_prefix=$xsbdir/config/$canonical

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
./testsuite.sh $execdir_prefix/bin/xsb

cd $xsbdir/build
echo "Configuring XSB with --enable-local-scheduling"
configure --config-tag=localsched --enable-local-scheduling >> $logfile
echo "Making XSB with --enable-local-scheduling"
makexsb --config-tag=localsched fast >> $logfile
cd $testdir
./testsuite.sh $execdir_prefix-localsched/bin/xsb

cd $xsbdir/build
echo "Configuring XSB with --enable-chat"
configure --config-tag=chat --enable-chat >> $logfile
echo "Making XSB with --enable-chat"
makexsb --config-tag=chat fast >> $logfile
cd $testdir
./testsuite.sh $execdir_prefix-chat/bin/xsb


cd $xsbdir/build
echo "Configuring XSB with --enable-chat --enable-local-scheduling"
configure --config-tag=localschedNchat --enable-chat --enable-local-scheduling >> $logfile
echo "Making XSB with --enable-chat --enable-local-scheduling"
makexsb --config-tag=localschedNchat fast >> $logfile
cd $testdir
./testsuite.sh $execdir_prefix-localschedNchat/bin/xsb

rm $testdir/$lockfile
