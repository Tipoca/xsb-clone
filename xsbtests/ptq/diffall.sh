#! /bin/sh

echo "--------------------------------------------------------"

suffixes="s iv cn te1"

for suff in $suffixes ; do
    infile=$2_${suff}1
    outfile=$1_${suff}
    outfile1=$1_${suff}1
    test -f "$infile" || touch "$infile"

    status=0
    diff $outfile1 $infile || status=1
    if test "$status" = 0 ; then
	echo "$outfile1 tested"
    else
	echo "$outfile1 and $infile differ!!!"
    fi

    /bin/rm -f $outfile1 $outfile
done
