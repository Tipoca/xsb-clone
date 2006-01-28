PREF=$1
DIR=$2

rm -rf $DIR
mkdir $DIR

./test.sh $PREF/bin/xsb $DIR/prolog-seq.P
./test.sh $PREF/bin/xsb-mt $DIR/prolog-mt.P
