#! /bin/sh

# $1 is expected to have xsb ececutable + command line options
EMU=$1
COMP_CMD=$2
CMD=$3

DIR=`pwd`
BASEDIR=`basename $DIR`

#echo "--------------------------------------------------------------------"
#echo "Benching $BASEDIR/$FILE"
#echo "$EMU"     # debug check: verify that options have been passed to xsb

$EMU << EOF
$COMP_CMD

$CMD

EOF

