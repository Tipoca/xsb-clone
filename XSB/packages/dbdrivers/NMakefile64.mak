
ALL::
	cd cc
	nmake /f NMakefile64.mak
	cd ..\odbc
	del odbc_init.P
	copy Misc\odbc_init-wind.P  odbc_init.P
	cd cc
	nmake /f NMakefile64.mak
	cd ..\..\mysql
	del mysql_init.P
	copy Misc\mysql_init-wind.P  mysql_init.P
	cd cc
#   nmake /f NMakefile64.mak
	cd ..\..\mysqlembedded
	del mysqlembedded_init.P
	copy Misc\mysqlembedded_init-wind.P  mysqlembedded_init.P
	cd cc
#   nmake /f NMakefile64.mak
	cd ..\..
