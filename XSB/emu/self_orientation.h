/* File:      self_orientation.h
** Author(s): Michael Kifer
** Contact:   xsb-contact@cs.sunysb.edu
** 
** Copyright (C) The Research Foundation of SUNY, 1998
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
** $Id: self_orientation.h,v 1.2 1999-05-03 00:55:51 luis Exp $
** 
*/
#include "export.h"

DllExport extern void call_conv set_xsbinfo_dir (void);
DllExport extern void call_conv set_install_dir(void);
DllExport extern void call_conv set_config_file(void);
DllExport extern void call_conv set_user_home(void);
DllExport extern char * call_conv xsb_executable_full_path(char *);
extern char executable[];

