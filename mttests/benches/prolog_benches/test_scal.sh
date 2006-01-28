PREF=$1
DIR=$2
MAX=$3

nthreads=1
while [ $nthreads -le $MAX ]
do
	./mttest.sh $PREF/bin/xsb-mt $DIR/prolog.P $nthreads 
	nthreads=$[$nthreads*2]
done

