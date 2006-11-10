PREF=$1
DIR=$2
MAX=$3

./make_graphs.sh $PREF/bin/xsb

nthreads=1
while [ $nthreads -le $MAX ]
do
	./mttest.sh $PREF/bin/xsb-mt \
		    $DIR/shared-local.P $nthreads 
	./mttest.sh $PREF/bin/xsb-btc-ccmpl \
		    $DIR/shared-batched.P $nthreads
	nthreads=$[$nthreads*2]
done

