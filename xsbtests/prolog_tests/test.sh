#! /bin/sh

echo "-------------------------------------------------------"
echo "--- Running prolog_tests/test.sh                    ---"
echo "-------------------------------------------------------"

XEMU=$1
options=$2

#------------------------------------
# tests involving standard predicates
#------------------------------------
    # XEMU and options must be together in quotes
#../gentest.sh "$XEMU $options" arith_op "test."
../gentest.sh "$XEMU $options" std1 "test."
../gentest.sh "$XEMU $options" std2 "test."
#------------------------------------
# Test reading from strings
#------------------------------------
../gentest.sh "$XEMU $options" readstrtest "test."
#------------------------------------
# Test number_chars
#------------------------------------
../gentest.sh "$XEMU $options" n2c "test."
#------------------------------------
# keep the compiler honest
#------------------------------------
../gentest.sh "$XEMU $options" first "test."
../gentest.sh "$XEMU $options" newfirst "test."
#-----------------------------------------------------------------------
# the following make sure that the compiler will produce the right code
#-----------------------------------------------------------------------
../gentest.sh "$XEMU $options" inline "go."
../gentest.sh "$XEMU $options" unsafe1 "test."
../gentest.sh "$XEMU $options" unsafe2 "test."
../gentest.sh "$XEMU $options" varcond "test."
#-----------------------------------------------------------------------
# the following two tests are used to test multifile directive
#-----------------------------------------------------------------------
#------------------------------------
# Just to create some OBJ files that
# will be used later in multifile test
#------------------------------------
../gentest.sh "$XEMU $options" mf_obj "do."
#------------------------------------
# Test multifile directive
#------------------------------------
../gentest.sh "$XEMU $options" mf_test1 "test."
#------------------------------------
# Test reading constant characters
#------------------------------------
../gentest.sh "$XEMU $options" con_char "test."
#------------------------------------
# Test evaluable functions
#------------------------------------
../gentest.sh "$XEMU $options" conv_fun "test."
#------------------------------------
# Test format library
#------------------------------------
../gentest.sh "$XEMU $options" format_test "test."
#------------------------------------
# Test listing/0
#------------------------------------
../gentest.sh "$XEMU $options" listing_test "test."

#------------------------------------
# Test write_term library
#------------------------------------
../gentest.sh "$XEMU $options" wttest "test."

#------------------------------------
# Rare specialization bug test
#------------------------------------
../gentest.sh "$XEMU $options" spec_tbl_fold_bug "test."

#------------------------------------------------------------------------
# Test Prolog calling C: the .so or .o file needs to be created each time
#------------------------------------------------------------------------

OBJEXT=.xwam
os_type=`uname -s`
if test "$os_type" = "HP-UX" ; then
	echo "Foreign language interface tests bypassed"
else
#------------------------------------------------------------------------
	rm -f xeddis.o xeddis.so xeddis$OBJEXT
	../gentest.sh "$XEMU $options" cinter1 "test."
#------------------------------------------------------------------------
	rm -f zero.o zero.so zero$OBJEXT
	../gentest.sh "$XEMU $options" cinter2 "test."
#------------------------------------------------------------------------
	rm -f c_calls_xsb.o c_calls_xsb$OBJEXT c_calls_xsb_make$OBJEXT
	../gentest.sh "$XEMU $options" c_calls_xsb_make "test."
fi
