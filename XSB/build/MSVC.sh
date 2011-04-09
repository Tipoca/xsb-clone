#! /bin/sh

cat <<EOF  > .makedepend.tmp
# DO NOT DELETE THIS LINE -- make  depend  depends  on it.

EOF

cd ../emu

configdir=../config/x86-pc-windows

# -w2000 tells makedepend to create long line, 1 dependency per source file:
# we don't know how MSVC's NMAKE handles multiple dependencies per source file
# -Y tells not to bother with system include dirs:
# they aren't important as dependencies
# Grep is here so that the warnings about system include files
# won't be displayed.
makedepend -w2000 -f ../build/.makedepend.tmp -o.obj -p@@@ -Y -- -I$configdir -- *c 2>&1 \
	| grep -v "cannot find include" | grep -v "not in"

TODOS=`which todos`
U2D=`which unix2dos`
if test -n "$TODOS" ; then
    UNIX2DOS_CMD=$TODOS
elif test -n "$U2D" ; then
    UNIX2DOS_CMD=$U2D
else
    echo "*** Warning: The commands 'todos' and 'unix2dos' are not installed."
    echo "***          Recompilation under Windows will be slower."
    UNIX2DOS_CMD=
fi

# Convert Unix Makefile dependencies to NMAKE format, add ^M at the end
if test -n "$UNIX2DOS_CMD" ; then
    cat ../build/.makedepend.tmp | sed  -f ../build/MSVC.sed | $UNIX2DOS_CMD > ../build/MSVC.dep
else
    rm -f ../build/MSVC.dep
    ../build/touch.sh  ../build/MSVC.dep
fi


