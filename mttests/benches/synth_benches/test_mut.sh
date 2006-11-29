PREF=$1
DIR=$2

./mut_test.sh $PREF/bin/xsb-mt $DIR/mut-synth-loc.txt
./mut_test.sh $PREF/bin/xsb-btc-ccmpl $DIR/mut-synth-bat.txt
