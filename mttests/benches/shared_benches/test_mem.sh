PREF=$1
DIR=$2
MAX=$3

ARCH=`${PREF}/build/config.guess`

./make_graphs.sh $PREF/bin/xsb

nthreads=1
while [ $nthreads -le $MAX ]
do
	./mmttest.sh $PREF/config/${ARCH}-mt/bin/xsb \
		    $DIR/mem-shared-local.txt $nthreads 
	./mmttest.sh $PREF/config/${ARCH}-btc-ccmpl/bin/xsb \
		    $DIR/mem-shared-batched.txt $nthreads
	nthreads=$[$nthreads*2]
done

