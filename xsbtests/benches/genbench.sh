#! /bin/sh

# $1 is expected to have xsb executable + command line options
EMU=$1
COMP_CMD=$2
CMD=$3
FILE=$4

DIR=`pwd`
BASEDIR=`basename $DIR`

#echo "--------------------------------------------------------------------"
#echo "Benching $BASEDIR/$FILE"
#echo "$EMU"     # debug check: verify that options have been passed to xsb

$EMU << EOF
$COMP_CMD
tell(temp).
$CMD
told.
EOF

# accumulate results in FILE for later analysis.
if test -f $FILE ; then
    mv $FILE ${FILE}_tmp
    cat ${FILE}_tmp temp > $FILE
    rm ${FILE}_tmp temp
else
    mv temp $FILE
fi
