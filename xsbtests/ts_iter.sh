
XSBDIR=$1

 echo "--------------- dbg test -------------------------"
 
 cd ../XSB/build
 
 rm ../config/*dbg/saved.o/*.o ; 
 configure --enable-debug > /tmp/config ; 
 makexsb --config-tag=dbg ;
 
 cd ../../tests
 
 sh testsuite.sh -tag dbg  $XSBDIR
 
 echo "--------------- mt-dbg test -------------------------"
 
 cd ../XSB/build
 
 rm ../config/*dbg-mt/saved.o/*.o ; 
 configure --enable-mt --enable-debug > /tmp/config ; 
 makexsb --config-tag=dbg-mt ;
 
 cd ../../tests
 
 sh testsuite.sh -tag dbg-mt -exclude regmatch_tests  $XSBDIR
 
echo "--------------- opt test -------------------------"

cd ../XSB/build

rm ../config/*-dflt/saved.o/*.o ; 
Configure --config-tag=dflt > /tmp/config ; 
makexsb --config-tag=dflt ;

cd ../../tests

sh testsuite.sh -tag "dflt"  $XSBDIR

 echo "--------------- mt-opt test -------------------------"
 
 cd ../XSB/build
 
 rm ../config/*mt/saved.o/*.o ; 
 configure --enable-mt  > /tmp/config ; 
 makexsb --config-tag=mt ;
 
 cd ../../tests
 
 sh testsuite.sh -tag mt -exclude regmatch_tests  $XSBDIR
 
 echo "--------------- batched test -------------------------"
 
 cd ../XSB/build
 
 rm ../config/*mt/saved.o/*.o ; 
 configure --enable-batched  > /tmp/config ; 
 makexsb --config-tag=btc ;
 
 cd ../../tests
 
 sh testsuite.sh -tag btc $XSBDIR
 
