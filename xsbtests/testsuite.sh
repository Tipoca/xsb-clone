#! /bin/sh

## File:      testsuite.sh
## Author(s): Juliana Freire
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
## $Id: testsuite.sh,v 1.13 1999-02-23 17:56:17 kostis Exp $
## 
##

#==================================================================
# This is supposed to automate the testsuite by checking the
# log for possible errors.
#==================================================================

# $1 is expected to be the path to XSB installation directory
# $2 is optional. If specified, this is the tag to use to 
#    locate the XSB executable (e.g., dbg, chat, etc.). 
#    It is usually specified using the --config-tag option of 'configure'
#    The XSB executable is either in
#    	 $1/config/architecture/bin/xsb
#    or in
#    	 $1/config/architecture-$2/bin/xsb
#    depending on whether the configuration tag was given on command line.
# $3 is optional.  If specified, it is the file containing the commands
#    to test specific subdirectories of the XSB testsuite.  If not
#    specified it defaults to "testall".

echo ==========================================================================


if test $# -gt 3 -o $# = 0; then
	echo "Usage: testsuite.sh <full path for XSB installation directory>"
	echo ""
	exit
fi

if test -n "$USER"; then
   USER=`whoami`
   export USER
fi


installdir=$1

if test -z "$2" ; then
    config_tag=
else
    config_tag="-$2"
fi

config=`$installdir/build/config.guess`
canonical=`$installdir/build/config.sub $config`

XEMU=$installdir/config/$canonical$config_tag/bin/xsb

if test -z "$3" ; then
    sh_testfile="./testall.sh"
else
    sh_testfile="$3"
fi

GREP="grep -i"
MSG_FILE=/tmp/xsb_test_msg.$USER
LOG_FILE=/tmp/xsb_test_log.$USER
LOG_FILE_LOCAL=xsb_test_log.$USER
RES_FILE=/tmp/xsb_test_res.$USER

if test ! -x "$XEMU"; then
    echo "Can't execute $XEMU"
    echo "aborting..."
    echo "Can't execute $XEMU" >$MSG_FILE
    HOSTNAME=`hostname`
    echo "Aborted testsuite on $HOSTNAME..." >> $MSG_FILE
    # Mail does not work on the HP
    #	Mail -s "Testsuite aborted" $USER@cs.sunysb.edu < $MSG_FILE
    mail $USER < $MSG_FILE
    rm -f $MSG_FILE
    exit
fi

if test -f "$RES_FILE"; then
  echo "There was an old $RES_FILE"
  echo "removing..."
  rm -f $RES_FILE
fi


if test -f "$LOG_FILE"; then
  echo "There was an old $LOG_FILE"
  echo "removing..."
  rm -f $LOG_FILE
fi



# should parameterize: create a script that given an input file
# greps for errors and prints the results to an output file
# and then this script can also be used in buildtest

echo "Testing $XEMU"
echo "Results will be in  $LOG_FILE"

echo "Log for  $XEMU" > $LOG_FILE
(echo "Date-Time: `date +"%y%m%d-%H%M"`" >> $LOG_FILE) || status=failed
if test -n "$status"; then
	echo "Date-Time: no date for NeXT..." >> $LOG_FILE
	NEXT_DATE=1
else
	NEXT_DATE=0
fi

$sh_testfile $XEMU >> $LOG_FILE 2>&1

echo "-----------------------------------------"
echo "The following core dumps occurred during this test run:"
find . -name core -print
echo "End of the core dumps list"
# check for seg fault
$GREP "fault" $LOG_FILE > $RES_FILE
# core dumped
$GREP "dumped" $LOG_FILE >> $RES_FILE
# when no output file is generated
$GREP "match" $LOG_FILE >> $RES_FILE
# for bus error
$GREP "bus" $LOG_FILE >> $RES_FILE
# for really bad outcomes
$GREP "missing" $LOG_FILE >> $RES_FILE
# for wrong results
$GREP "differ!" $LOG_FILE >> $RES_FILE
$GREP "different!" $LOG_FILE >> $RES_FILE
# when xsb aborts... it writes something like ! Aborting...
$GREP "abort" $LOG_FILE >> $RES_FILE
# for overflows (check for Overflow & overflow)
$GREP "overflow" $LOG_FILE >> $RES_FILE
# for ... missing command...
$GREP "not found" $LOG_FILE >> $RES_FILE
$GREP "abnorm" $LOG_FILE >> $RES_FILE
$GREP "denied" $LOG_FILE >> $RES_FILE
$GREP "no such file" $LOG_FILE >> $RES_FILE
$GREP "illegal" $LOG_FILE >> $RES_FILE
# sometimes after overflow the diff fails and a message with Missing
# is displayed
$GREP "missing" $LOG_FILE >> $RES_FILE
# 
$GREP "fatal" $LOG_FILE >> $RES_FILE
# some other problems that should highlight bugs in the test suite
$GREP "syntax error" $LOG_FILE >> $RES_FILE
$GREP "cannot find" $LOG_FILE >> $RES_FILE
echo "-----------------------------------------"


if test "$NEXT_DATE" = 1; then
	NEW_LOG=$LOG_FILE.$NEXT_DATE
	cp $LOG_FILE $NEW_LOG
else
	NEW_LOG=$LOG_FILE.`date +"%y%m%d-%H%M"`
	cp $LOG_FILE $NEW_LOG
fi

HOSTNAME=`hostname`

# -s tests if size > 0
if test -s $RES_FILE; then
	cat $RES_FILE
	echo "-----------------------------------------"
	echo "***FAILED testsuite for $XEMU on $HOSTNAME"
        echo "***FAILED testsuite for $XEMU on $HOSTNAME" > $MSG_FILE
	echo "Check the log file $NEW_LOG" >> $MSG_FILE
	echo "" >> $MSG_FILE
	echo "The following is a summary of the problems:" >> $MSG_FILE
	cat $RES_FILE >> $MSG_FILE
	mail $USER < $MSG_FILE
	rm -f $MSG_FILE
else
	echo "PASSED testsuite for $XEMU on $HOSTNAME"
fi

rm -f $RES_FILE

echo "Done"
echo ==============================================================
