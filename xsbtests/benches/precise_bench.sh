#! /bin/sh

dir=$1
test=$2
emulator=$3

$emulator  << EOF

halt.
EOF

cd $1

x=0

while test $x -le 40
do
    $test "$emulator --nobanner --quietload --noprompt -o $x"
    x=`expr $x + 4`
done

