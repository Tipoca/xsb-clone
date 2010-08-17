/* File:      support_builtin.h
** Author(s): Spyros Hadjichristodoulou, Yuri Puzis
** Contact:   xsb-contact@cs.sunysb.edu
** 
** Copyright (C) The Research Foundation of SUNY, 2010
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
/* Pseudo-builtin definitions */

#define INCR_ASSERT	    1
#define RETURN_E            2
#define SET_MODE            3
#define GET_DIRTY_COUNT     4
#define UPDATE              5
#define ENTER_DELTA_MINUS   6
#define FAST_TRIE_INTERN    7
#define GET_MODE            8
#define INCR_TRIE_DISPOSE   9

/* Make the compiler stop complaining about implicit declarations */

/* From biassert.c */
extern int increm_assert(CTXTdecl);

/* From tries.c */
extern void bottomupunify(CTXTdeclc Cell, BTNptr, BTNptr);

/* From tr_utils.c */
extern VariantSF get_dirty_count(Cell,int *);
extern void fast_intern(prolog_term);

/* From support.c */
extern void dred(void);


