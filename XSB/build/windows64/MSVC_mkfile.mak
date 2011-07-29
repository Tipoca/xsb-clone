#   MSVC_mkfile.mak:  Makefile to compile XSB on Windows using VC++ NMAKE
#   windows64/MSVC_mkfile.mak.  Generated from MSVC_mkfile.in by configure.
#
# Usage:
#   NMAKE /f "MSVC_Mfile.mak"
#

### Custom compilation: the file custom_settings.mak
###
### To compile with native Oracle support, put this in custom_settings.mak:
### ORACLE=yes
### In this case, also add the appropriate
###  /LIBPATH:"oracle_library1" /LIBPATH:"oracle_library2" ...
### to MY_LIBRARY_DIRS (see below), where Oracle libraries should be taken
### from the Oracle manual.
###
### To compile with debugging options, add this:
### DEBUG=yes
###
### If you have custom directories to use for #include commands or DLLs,
### create the file custom_settings.mak and put these lines there
### MY_INCLUDE_DIRS=/I"incdir1" /I"incdir2" ...
### MY_LIBRARY_DIRS=/LIBPATH:"libdir1" /LIBPATH:"libdir2" ...
###     For instance, to configure with support for threads, add
###     /LIBPATH:"pthreadVC1.lib" to MY_LIBRARY_DIRS in custom_settings.mak
###     and configure with --enable-mt
### XSB_INTERPROLOG=yes/true/1 can also be specified here, if needed
###                 In this case, MY_INCLUDE_DIRS should point to the
###                 directories that contain jni.h and jni_md.h

!IF EXIST("..\build\windows64\custom_settings.mak")
!INCLUDE "..\build\windows64\custom_settings.mak"
!ENDIF

CONFIGDIR=..\config\x64-pc-windows
CONFIG_INCLUDE_FLAG=/I"$(CONFIGDIR)" $(MY_INCLUDE_DIRS)
SITE_LIBS= $(MY_LIBRARY_DIRS)

!IF "$(DLL)" != "no"
DLL=yes
!ENDIF

# $(CALLCONV) can be "cdecl"  or "stdcal"
!IF "$(CALLCONV)" != "cdecl"
CALLCONV=stdcal
!ENDIF

!IF "$(ORACLE)" != "yes"
ORACLE=no
!ENDIF

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE
NULL=nul
!ENDIF

################################################################################
# Begin Project
CPP=cl.exe

# Assume we are running NMAKE in the emu directory
#!IF  "$(DLL)" == "yes"
# Put DLL in the bin directory
DLLDIR=$(CONFIGDIR)\bin
OUTDIR=$(CONFIGDIR)\bin
#!ELSE
#OUTDIR=$(CONFIGDIR)\bin
#!ENDIF

OBJDIR=$(CONFIGDIR)\saved.o

INTDIR=.

!IF "$(CALLCONV)" == "cdecl"
CALL_CONV=XSB_DLL_C
!ELSE
CALL_CONV=XSB_DLL
!ENDIF

!IF  "$(ORACLE)" == "yes"
ORACLE_FLAG=/D "ORACLE"
ORACLE_MSG=with Oracle support
!IF  "$(SITE_LIBS)" == ""
!ERROR Oracle libraries must be specified, if building XSB with native interface to Oracle
!ENDIF
!ENDIF


!IF  "$(XSB_INTERPROLOG)" == "yes" || "$(XSB_INTERPROLOG)" == "true" || "$(XSB_INTERPROLOG)" == "1"
INTERPROLOG_FLAG=/D "XSB_INTERPROLOG"
INTERPROLOG_MSG=with support for InterProlog's native engine
!ENDIF

!IF "$(DLL)" == "yes"
ALL:: "$(DLLDIR)\xsb.dll" "$(OUTDIR)\xsb.exe"
!ELSE
ALL:: "$(OUTDIR)\xsb.exe"
!ENDIF

SOCKET_LIBRARY=wsock32.lib

"$(OUTDIR)" :
	if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_OBJS=$(OBJDIR)/
CPP_SBRS=
LINK32=link.exe
DLL_LINK32_OBJS= \
	"$(OBJDIR)/auxlry.obj" \
	"$(OBJDIR)/builtin.obj" \
	"$(OBJDIR)/biassert.obj" \
	"$(OBJDIR)/call_graph_xsb.obj" \
	"$(OBJDIR)/cinterf.obj" \
	"$(OBJDIR)/deadlock.obj" \
	"$(OBJDIR)/debug_xsb.obj" \
	"$(OBJDIR)/dis.obj" \
	"$(OBJDIR)/dynload.obj" \
	"$(OBJDIR)/dynamic_stack.obj" \
	"$(OBJDIR)/emuloop.obj" \
	"$(OBJDIR)/error_xsb.obj" \
	"$(OBJDIR)/findall.obj" \
	"$(OBJDIR)/function.obj" \
	"$(OBJDIR)/hash_xsb.obj" \
	"$(OBJDIR)/hashtable_xsb.obj" \
	"$(OBJDIR)/hashtable.obj" \
	"$(OBJDIR)/hashtable_itr.obj" \
	"$(OBJDIR)/heap_xsb.obj" \
	"$(OBJDIR)/url_encode.obj" \
	"$(OBJDIR)/incr_xsb.obj" \
	"$(OBJDIR)/init_xsb.obj" \
	"$(OBJDIR)/inst_xsb.obj" \
	"$(OBJDIR)/io_builtins_xsb.obj" \
	"$(OBJDIR)/loader_xsb.obj" \
	"$(OBJDIR)/memory_xsb.obj" \
	"$(OBJDIR)/odbc_xsb.obj" \
	"$(OBJDIR)/orient_xsb.obj" \
	"$(OBJDIR)/pathname_xsb.obj" \
	"$(OBJDIR)/psc_xsb.obj" \
	"$(OBJDIR)/private_builtin.obj" \
	"$(OBJDIR)/random_xsb.obj" \
	"$(OBJDIR)/remove_unf.obj" \
	"$(OBJDIR)/residual.obj" \
	"$(OBJDIR)/rw_lock.obj" \
	"$(OBJDIR)/scc_xsb.obj" \
	"$(OBJDIR)/slgdelay.obj" \
	"$(OBJDIR)/struct_manager.obj" \
	"$(OBJDIR)/storage_xsb.obj" \
	"$(OBJDIR)/sub_delete.obj" \
	"$(OBJDIR)/subp.obj" \
	"$(OBJDIR)/system_xsb.obj" \
	"$(OBJDIR)/table_stats.obj" \
	"$(OBJDIR)/tables.obj" \
	"$(OBJDIR)/thread_xsb.obj" \
	"$(OBJDIR)/timer_xsb.obj" \
	"$(OBJDIR)/token_xsb.obj" \
	"$(OBJDIR)/trace_xsb.obj" \
	"$(OBJDIR)/trie_lookup.obj" \
	"$(OBJDIR)/trie_search.obj" \
	"$(OBJDIR)/tries.obj" \
	"$(OBJDIR)/tr_utils.obj" \
	"$(OBJDIR)/tst_insert.obj" \
	"$(OBJDIR)/tst_retrv.obj" \
	"$(OBJDIR)/tst_unify.obj" \
	"$(OBJDIR)/tst_utils.obj" \
	"$(OBJDIR)/socket_xsb.obj" \
	"$(OBJDIR)/string_xsb.obj" \
	"$(OBJDIR)/varstring.obj" \
	"$(OBJDIR)/ubi_BinTree.obj" \
	"$(OBJDIR)/ubi_SplayTree.obj"

# DLLs don't use main_xsb.c
!IF  "$(DLL)" == "no"
LINK32_OBJS=$(DLL_LINK32_OBJS) $(OBJDIR)/main_xsb.obj
!ELSE
LINK32_OBJS=$(OBJDIR)/main_xsb.obj
!ENDIF

# Oracle requires one additional file
!IF "$(ORACLE)" == "yes"
!IF "$(DLL)" == "yes"
DLL_LINK32_OBJS=$(DLL_LINK32_OBJS) $(OBJDIR)/orastuff.obj
!ELSE
LINK32_OBJS=$(LINK32_OBJS) $(OBJDIR)/orastuff.obj
!ENDIF
!ENDIF

# InterProlog's native engine requires one additional file
!IF "$(XSB_INTERPROLOG)" != ""
!IF "$(DLL)" == "yes"
DLL_LINK32_OBJS=$(DLL_LINK32_OBJS) $(OBJDIR)/interprolog_callback.obj
!ELSE
LINK32_OBJS=$(LINK32_OBJS) $(OBJDIR)/interprolog_callback.obj
!ENDIF
!ENDIF

!IF  "$(DEBUG)" != "yes"  &&  "$(DLL)" == "no"
!MESSAGE Building XSB without DLL in Release mode $(ORACLE_MSG) $(INTERPROLOG_MSG)

DEBUG_CPP_FLAGS=/MT /O2 /D "NDEBUG"
LINK_DEBUG_FLAGS=/incremental:no /debug

!ELSEIF  "$(DEBUG)" == "yes"  &&  "$(DLL)" == "no"
!MESSAGE Building XSB executable in Debug mode $(ORACLE_MSG) $(INTERPROLOG_MSG)

DEBUG_CPP_FLAGS=/MTd /Gm /Zi /Od /D "_DEBUG" /D "DEBUG" /Fd"$(INTDIR)/"
LINK_DEBUG_FLAGS=/debug

!ELSEIF "$(DEBUG)" != "yes" && "$(DLL)" == "yes"
!MESSAGE Building XSB with DLL in Release mode $(ORACLE_MSG) $(INTERPROLOG_MSG)

DEBUG_CPP_FLAGS=/MT /O2 /D "NDEBUG"
DLL_CPP_FLAGS=/D "$(CALL_CONV)"
LINK_DEBUG_FLAGS=$(DLLDIR)"\xsb.lib" /incremental:no
DLL_LINK_DEBUG_FLAGS=/incremental:no

!ELSEIF "$(DEBUG)" == "yes" &&  "$(DLL)" == "yes"
!MESSAGE Building XSB with DLL in Debug mode $(ORACLE_MSG) $(INTERPROLOG_MSG)

DEBUG_CPP_FLAGS=/MTd /Gm /Zi /Od /D "_DEBUG" /D "DEBUG" /Fd"$(INTDIR)/"
DLL_CPP_FLAGS=/D "$(CALL_CONV)"
LINK_DEBUG_FLAGS=/debug $(DLLDIR)"\xsb.lib" 
DLL_LINK_DEBUG_FLAGS=/debug

!ENDIF

CPP_PROJ=\
	/nologo /W3 /EHsc /D "WIN64" /D "_CONSOLE" /c /Fp"$(OBJDIR)/xsb.pch" \
	/D "_CRT_SECURE_NO_WARNINGS" /Fo"$(OBJDIR)/" \
	$(CONFIG_INCLUDE_FLAG) $(ORACLE_FLAG) \
	$(INTERPROLOG_FLAG) $(DEBUG_CPP_FLAGS) \
	$(DLL_CPP_FLAGS)

LINK32_FLAGS=\
	/nologo \
	/subsystem:console \
	/machine:x64 \
	$(LINK_DEBUG_FLAGS) \
	$(SOCKET_LIBRARY) \
	$(SITE_LIBS) \
	kernel32.lib \
	user32.lib \
	gdi32.lib \
	winspool.lib \
	comdlg32.lib \
	advapi32.lib \
	shell32.lib \
	ole32.lib \
	oleaut32.lib \
	uuid.lib \
	odbc32.lib \
	odbccp32.lib \
	/pdb:"$(OUTDIR)/xsb.pdb" \
	/out:"$(OUTDIR)/xsb.exe"

DLL_CPP_PROJ=$(CPP_PROJ) /D "_WINDOWS"
DLL_LINK32_FLAGS=\
	/nologo \
	/subsystem:windows \
	/dll \
	/machine:x64 \
	$(SOCKET_LIBRARY) \
	$(SITE_LIBS) \
	kernel32.lib \
	user32.lib \
	gdi32.lib \
	winspool.lib \
	comdlg32.lib \
	advapi32.lib \
	shell32.lib \
	ole32.lib \
	oleaut32.lib \
	uuid.lib \
	odbc32.lib \
	odbccp32.lib \
	$(DLL_LINK_DEBUG_FLAGS) \
	/implib:"$(DLLDIR)/xsb.lib" \
	/pdb:"$(DLLDIR)/xsbdll.pdb" \
	/out:"$(DLLDIR)/xsb.dll"

"$(OUTDIR)\xsb.exe" : "$(OBJDIR)" $(DEF_FILE) $(LINK32_OBJS)
	-@$(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

"$(DLLDIR)\xsb.dll" : "$(DLLDIR)" $(DEF_FILE) $(DLL_LINK32_OBJS)
	-@$(LINK32) @<<
  $(DLL_LINK32_FLAGS) $(DLL_LINK32_OBJS)
<<

.c{$(CPP_OBJS)}.obj:
   -@$(CPP) $(CPP_PROJ) $<

.cpp{$(CPP_OBJS)}.obj:
   -@$(CPP) $(CPP_PROJ) $<

.cxx{$(CPP_OBJS)}.obj:
   -@$(CPP) $(CPP_PROJ) $<

.c{$(CPP_SBRS)}.sbr:
   -@$(CPP) $(CPP_PROJ) $<

.cpp{$(CPP_SBRS)}.sbr:
   -@$(CPP) $(CPP_PROJ) $<

.cxx{$(CPP_SBRS)}.sbr:
   -@$(CPP) $(CPP_PROJ) $<

CLEAN :
	-@erase "$(OBJDIR)\gpp.obj"
	-@erase "$(OBJDIR)\auxlry.obj"
	-@erase "$(OBJDIR)\biassert.obj"
	-@erase "$(OBJDIR)\builtin.obj"
        -@erase "$(OBJDIR)\call_graph_xsb.obj"	
	-@erase "$(OBJDIR)\cinterf.obj"
	-@erase "$(OBJDIR)\deadlock.obj"
	-@erase "$(OBJDIR)\debug_xsb.obj"
	-@erase "$(OBJDIR)\dis.obj"
	-@erase "$(OBJDIR)\dynload.obj"
	-@erase "$(OBJDIR)\dynamic_stack.obj"
	-@erase "$(OBJDIR)\emuloop.obj"
	-@erase "$(OBJDIR)\findall.obj"
	-@erase "$(OBJDIR)\function.obj"
	-@erase "$(OBJDIR)\hash_xsb.obj"
	-@erase "$(OBJDIR)\hashtable_xsb.obj"
	-@erase "$(OBJDIR)\hashtable.obj"
	-@erase "$(OBJDIR)\hashtable_itr.obj"
	-@erase "$(OBJDIR)\heap_xsb.obj"
	-@erase "$(OBJDIR)\inst_xsb.obj"
	-@erase "$(OBJDIR)\init_xsb.obj"
	-@erase "$(OBJDIR)\url_encode.obj"
	-@erase "$(OBJDIR)\incr_xsb.obj"
	-@erase "$(OBJDIR)\interprolog_callback.obj"
	-@erase "$(OBJDIR)\io_builtins_xsb.obj"
	-@erase "$(OBJDIR)\loader_xsb.obj"
	-@erase "$(OBJDIR)\main_xsb.obj"
	-@erase "$(OBJDIR)\memory_xsb.obj"
	-@erase "$(OBJDIR)\orastuff.obj"
	-@erase "$(OBJDIR)\orient_xsb.obj"
	-@erase "$(OBJDIR)\psc_xsb.obj"
	-@erase "$(OBJDIR)\private_builtin.obj"
	-@erase "$(OBJDIR)\random_xsb.obj"
	-@erase "$(OBJDIR)\remove_unf.obj"
	-@erase "$(OBJDIR)\residual.obj"
	-@erase "$(OBJDIR)\rw_lock.obj"
	-@erase "$(OBJDIR)\scc_xsb.obj"
	-@erase "$(OBJDIR)\slgdelay.obj"
	-@erase "$(OBJDIR)\struct_manager.obj"
	-@erase "$(OBJDIR)\storage_xsb.obj"
	-@erase "$(OBJDIR)\sub_delete.obj"
	-@erase "$(OBJDIR)\subp.obj"
	-@erase "$(OBJDIR)\system_xsb.obj"
	-@erase "$(OBJDIR)\table_stats.obj"
	-@erase "$(OBJDIR)\tables.obj"
	-@erase "$(OBJDIR)\thread_xsb.obj"
	-@erase "$(OBJDIR)\timer_xsb.obj"
	-@erase "$(OBJDIR)\token_xsb.obj"
	-@erase "$(OBJDIR)\trace_xsb.obj"
	-@erase "$(OBJDIR)\trie_lookup.obj"
	-@erase "$(OBJDIR)\trie_search.obj"
	-@erase "$(OBJDIR)\tries.obj"
	-@erase "$(OBJDIR)\tr_utils.obj"
	-@erase "$(OBJDIR)\tst_insert.obj"
	-@erase "$(OBJDIR)\tst_retrv.obj"
	-@erase "$(OBJDIR)\tst_unify.obj"
	-@erase "$(OBJDIR)\tst_utils.obj"
	-@erase "$(OBJDIR)\pathname_xsb.obj"
	-@erase "$(OBJDIR)\odbc_xsb.obj"
	-@erase "$(OBJDIR)\error_xsb.obj"
	-@erase "$(OBJDIR)\socket_xsb.obj"
	-@erase "$(OBJDIR)\string_xsb.obj"
	-@erase "$(OBJDIR)\varstring.obj"
	-@erase "$(OBJDIR)\ubi_BinTree.obj"
	-@erase "$(OBJDIR)\ubi_SplayTree.obj"
	-@erase "$(OBJDIR)\xsb.pch"
	-@erase "$(OUTDIR)\xsb.exe"
	-@erase "$(OUTDIR)\xsb.dll"
	-@erase "$(OUTDIR)\xsb.lib"
	-@erase "$(OUTDIR)\xsb.exp"
	-@erase "$(OUTDIR)\gpp.exe"


# Local Variables:
# coding-system-for-write: iso-2022-7bit-dos
# End:
