#! /bin/sh

XEMU=$3

suffixes="s te1 cn iv s1 te11 cn1 iv1"
for suff in $suffixes ; do
    file=$2_$suff
    test -f "$file" &&  /bin/rm -f $file
done

$XEMU -m 4000 -c 2000 -i << EOF
[ptq,tables].
$1.
output_table(s(_,_,_,_,_),$2_s).
output_table(te1(_,_,_,_,_,_,_),$2_te1).
output_table(cn(_,_,_,_,_,_),$2_cn).
output_table(iv(_,_,_,_,_,_),$2_iv).
halt.
EOF

suffixes="iv s te1 cn"
for suff in $suffixes ; do
    file=$2_$suff
    sort -u $file > ${file}1
done
