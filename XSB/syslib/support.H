/* File:      support.H
** Author(s): Spyros Hadjichristodoulou, Yury Puzis
** Contact:   xsb-contact@cs.sunysb.edu
** 
** Copyright (C) The Research Foundation of SUNY, 1986, 1993-1998, 2010
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
** 
*/

:- export
	enter_delta_minus/1,
	gc_red/1,
	update/1,
	addition/1,
	set_strata_num_table/2,
	rederive/0,
	return_e/2,
	current_timestamp/4,
	get_global_timestamp/1,
	incr_global_timestamp/1,
	get_dirty_count/2,
	set_mode/1,
	get_mode/3,
	max_support_size/2,
	increm_assert/1, /* Renamed from incr_assert */
	support_builtin/11.

:- import conpsc/2,
	psc_arity/2 from machine.
:- import convert_to_dyna/3,
	  check_assert/2 from assert.
:- import abort/1 from standard.

/* ------------------- end of file support.H --------------------------- */