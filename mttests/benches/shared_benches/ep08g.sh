PREF=$1
DIR=$2
MAX=$3

XEMU=$PREF/bin/xsb-mt
FILE=$DIR/graph.P

$XEMU << EOF
[make_graphs].

make_small_graphs.
EOF

nthreads=1
while [ $nthreads -le $MAX ]
do

        ../genbench.sh "$XEMU" "[trans_clos],readGraph(g2048x2)." \
		"mt_benches_2(g2048x2,2048,$nthreads)." "$FILE"
	nthreads=$[$nthreads*2]
done

