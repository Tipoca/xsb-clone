# Make file for sgml2pl.dll

XSBDIR=..\..\..
MYPROGRAM=sgml2pl
CURLDIR=..\..\curl\cc
HPROGRAM=load_page

CPP=cl.exe
OUTDIR=$(XSBDIR)\config\x64-pc-windows\bin
INTDIR=.

ALL : "$(OUTDIR)\$(MYPROGRAM).dll"

CLEAN :
	-@erase "$(INTDIR)\$(MYPROGRAM).obj"
	-@erase "$(INTDIR)\$(MYPROGRAM).dll"
	-@erase "$(INTDIR)\$(MYPROGRAM).exp"


CPP_PROJ=/nologo /MT /W3 /EHsc /O2 /I "$(XSBDIR)\config\x64-pc-windows" \
		 /I "$(XSBDIR)\emu" /I "$(XSBDIR)\prolog_includes" /I "$(XSBDIR)\packages\curl\cc" \
		 /I "$(XSBDIR)\packages\sgml\cc"\
		 /D "WIN_NT" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" \
		 /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /c 
	

SOURCE="$(CURLDIR)\$(HPROGRAM).c"
"$(CURLDIR)\$(HPROGRAM).obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

SOURCE=charmap.c error.c fetch_file.c model.c parser.c sgml2pl.c utf8.c util.c xmlns.c
"$(INTDIR)\$(MYPROGRAM).obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)

LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib \
		advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib \
		odbc32.lib odbccp32.lib xsb.lib wsock32.lib "$(CURLDIR)\bin\libcurl.lib" curl2pl.lib\
		/nologo /dll \
		/machine:x64 /out:"$(OUTDIR)\$(MYPROGRAM).dll" \
		/libpath:"$(XSBDIR)\config\x64-pc-windows\bin"	
LINK32_OBJS=  "$(CURLDIR)\$(HPROGRAM).obj" "$(INTDIR)\$(MYPROGRAM).obj"

"$(OUTDIR)\$(MYPROGRAM).dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<
