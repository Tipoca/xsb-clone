XEMU=$1
MAX=$2

FILE=./constrRes.P

rm -f $FILE

nthreads=1
while [ $nthreads -le $MAX ]
do

echo "-------------------- Testing $nthreads threads ------------------------------"

	../genbench.sh "$XEMU" "[benchmark_constraint]." \
			"private_scale_constr(501,$nthreads,1)." "$FILE"

	nthreads=$[$nthreads*2]
done

