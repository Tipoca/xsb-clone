/* File:      dynelf_xsb_i.h
** Author(s): Harald Schroepfer, Steve Dawson
** Contact:   xsb-contact@cs.sunysb.edu
** 
** Copyright (C) The Research Foundation of SUNY, 1986, 1993-1998
** Copyright (C) ECRC, Germany, 1990
** 
** XSB is free software; you can redistribute it and/or modify it under the
** terms of the GNU Library General Public License as published by the Free
** Software Foundation; either version 2 of the License, or (at your option)
** any later version.
** 
** XSB is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
** FOR A PARTICULAR PURPOSE.  See the GNU Library General Public License for
** more details.
** 
** You should have received a copy of the GNU Library General Public License
** along with XSB; if not, write to the Free Software Foundation,
** Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
**
** $Id: dynelf_xsb_i.h,v 1.13 2000-03-01 16:22:33 dwarren Exp $
** 
*/


#include <dlfcn.h>
#include <sys/file.h>
#include <sys/types.h>
#include <sys/stat.h>
/* special.h must be included after sys/stat.h */
#include "configs/special.h"
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "auxlry.h"
#include "cell_xsb.h"
#include "memory_xsb.h"
#include "inst_xsb.h"
#include "psc_xsb.h"
#include "error_xsb.h"
#include "io_builtins_xsb.h"
#include "varstring_xsb.h"

#define BUFFEXTRA 1024

#if (defined(SOLARIS) && defined(__GNUC__))
/* just to supress stupid gcc warning */
extern int putenv(const char *);
#endif

/*----------------------------------------------------------------------*/

static bool dummy(void)
{
  xsb_error("LOADER: Trying to use an undefined foreign procedure");
  return FALSE;
}

/*----------------------------------------------------------------------*/

static byte *load_obj_dyn(char *pofilename, Psc cur_mod, char *ld_option)
{
  char	*name;
  Pair	search_ptr;
  char	sofilename[MAXPATHLEN];
  void	*handle;
  void	*funcep;
  char  ldtemp; 
  char  *ldp1,*ldp2;
  static vstrDEFINE(ldstring_oldenv);
  static vstrDEFINE(ldstring_newenv);
  char  *libpath;
  
  /* (1) create filename.so */
  
  strcpy(sofilename, pofilename);
  /* replace the O suffix with the so suffix */
  strcpy(sofilename+strlen(pofilename)-1, "so");
  
  /* (1.5) include necessary paths into LD_LIBRARY_PATH
     so that the right libraries would be consulted at loading time.
     NOTE: Some systems (Solaris) ignore runtime changes of LD_LIBRARY_PATH,
     so adding these libraries won't help. This works on Linux, though.

     On systems where LD_LIBRARY_PATH can't be changed at runtime, one should
     build the runtime library search path into the .so module at compile
     time. Usually, this is done with the -R linker flag.
     XSB provides a predicate, runtime_loader_flag/2, which gives the
     appropriate loader flag, if possible.
  */

  libpath = getenv("LD_LIBRARY_PATH");
  if (libpath == NULL)
    libpath = "";
  vstrSET(&ldstring_oldenv,"LD_LIBRARY_PATH=");
  vstrAPPEND(&ldstring_oldenv, libpath);
  vstrSETV(&ldstring_newenv,&ldstring_oldenv);
  
  /* search for -Lpath, -L"paths" or -L'paths' */
  for (ldp1=ld_option; (*ldp1); ldp1++) {
    if (*ldp1 == '-' && *(ldp1+1) == 'L') {
      ldp1 += 2;
      ldp2 = ldp1;
      while (*ldp1 != ' ' && *ldp1 != '\0')
 	ldp1++;
      *ldp1 = '\0';
      ldtemp = *(ldp2-1);
      *(ldp2-1) = ':';
      vstrAPPEND(&ldstring_newenv, ldp2-1);
      *ldp1 = ' ';
      *(ldp2-1) = ldtemp;
    } else if (*ldp1 == '\'') {
      ldp1++;
      while (*ldp1 != '\'')
	ldp1++;
    } else if (*ldp1 == '\"') {
      ldp1++;
      while (*ldp1 != '\"')
 	ldp1++;
    }
  }
  
  if (putenv(ldstring_newenv.string) != 0)
    xsb_error("LOAD_OBJ_DYN: can't adjust LD_LIBRARY_PATH");
  
  /* (2) open the needed object */
  handle = dlopen(sofilename, RTLD_LAZY);

  if (putenv(ldstring_oldenv.string) != 0)
    xsb_error("LOAD_OBJ_DYN: can't restore the value of LD_LIBRARY_PATH");
  

  if (handle == 0) {
    xsb_mesg("%s", dlerror());
    return NULL;
  }

  
  /* (3) find address of function and data objects */
  search_ptr = (Pair)get_data(cur_mod);
  
  while (search_ptr) {
    name = get_name(search_ptr->psc_ptr);
    
    if (get_type(search_ptr->psc_ptr) == T_FORN) {
      if ((funcep = (int *) dlsym(handle, name)) == NULL) {
	fprintf(stdwarn, "%s\n", dlerror());
	xsb_warn("LOADER: Cannot find foreign procedure %s", name);
	set_forn(search_ptr->psc_ptr, (byte *)(dummy));
      } else { 
	set_forn(search_ptr->psc_ptr, (byte *)(funcep));
      }
      
    }
    search_ptr = search_ptr->next;
  }
  return (byte *)4;
}

