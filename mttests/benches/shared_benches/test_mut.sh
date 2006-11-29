PREF=$1
DIR=$2

./make_graphs.sh $PREF/bin/xsb

./mut_test.sh	$PREF/bin/xsb-mt	$DIR/mut-shared-loc.txt
./mut_test.sh	$PREF/bin/xsb-btc-ccmpl	$DIR/mut-shared-bat.txt
