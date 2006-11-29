PREF=$1
DIR=$2

./mut_test.sh $PREF/bin/xsb-mt $DIR/mut-tab-loc.txt
./mut_test.sh $PREF/bin/xsb-btc-ccmpl $DIR/mut-tab-bat.txt
