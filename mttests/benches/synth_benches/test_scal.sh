PREF=$1
DIR=$2
MAX=$3

for nthreads in 1 2 4 8 16 32 64 128 256
do
	if test $nthreads -le $MAX
	then
		./mttest.sh $PREF/bin/xsb-mt $DIR/synth-local.P $nthreads 
		./mttest.sh $PREF/bin/xsb-btc-ccmpl $DIR/synth-batched.P $nthreads 
	fi
done

