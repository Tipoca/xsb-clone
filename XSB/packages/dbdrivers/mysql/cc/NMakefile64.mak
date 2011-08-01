# Make file for mysql_driver.dll

# !!!!
# !!!! Replace with a correct path to MySQL!!!
#MySQLLib="<Insert Proper Path>\mysqlclient.lib"
#MySQLIncludeDir="<Insert Proper Path>"
# !!!! You may need to copy the mysql library files and header files to
# !!!! directories with no space in paths
# !!!! The following commented path doesn't work!
#MySQLLib="C:\Program Files\MySQL\MySQL Server 6.0\lib\opt\mysqlclient.lib"
#MySQLIncludeDir="C:\Program Files\MySQL\MySQL Server 6.0\include"

XSBDIR=..\..\..\..
MYPROGRAM=mysql_driver
DRIVER_MANAGER_LIB="$(XSBDIR)\config\x64-pc-windows\bin\driver_manager.lib"

CPP=cl.exe
OUTDIR=$(XSBDIR)\config\x64-pc-windows\bin
INTDIR=.

ALL : "$(OUTDIR)\$(MYPROGRAM).dll"
	nmake /f NMakefile64.mak clean

CLEAN :
	-@if exist "$(INTDIR)\$(MYPROGRAM).obj" erase "$(INTDIR)\$(MYPROGRAM).obj"
	-@if exist "$(INTDIR)\$(MYPROGRAM).dll" erase "$(INTDIR)\$(MYPROGRAM).dll"
	-@if exist "$(INTDIR)\$(MYPROGRAM).exp" erase "$(INTDIR)\$(MYPROGRAM).exp"


CPP_PROJ=/nologo /MT /W3 /EHsc /O2 /I "$(XSBDIR)\config\x64-pc-windows" \
		 /I "$(XSBDIR)\emu" /I "$(XSBDIR)\prolog_includes" \
		 /I "$(XSBDIR)\packages\dbdrivers\cc" \
		 /I "$(MySQLIncludeDir)" \
		 /D "WIN64" /D "WIN_NT" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" \
		 /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /c 
	

SOURCE=$(MYPROGRAM).c
"$(INTDIR)\$(MYPROGRAM).obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib \
		advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib \
		odbc32.lib odbccp32.lib \
		WS2_32.lib \
		$(DRIVER_MANAGER_LIB) $(MySQLLib) \
		/nologo /dll \
		/machine:x64 /out:"$(OUTDIR)\$(MYPROGRAM).dll"
LINK32_OBJS=  "$(INTDIR)\$(MYPROGRAM).obj"

"$(OUTDIR)\$(MYPROGRAM).dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<
