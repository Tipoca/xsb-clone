/* File:      support.h
** Author(s): Spyros Hadjichristodoulou, Yury Puzis
** Contact:   xsb-contact@cs.sunysb.edu
** 
** Copyright (C) The Research Foundation of SUNY, 1986, 1993-1998, 2010
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
** $Id: $
** 
*/

#include "tries.h"

/*================================================================*/
/*                   Imported Variables                           */
/*================================================================*/

/* These may not be necessary */
extern int support_mode;
extern setsupportnodeptr current_ssn;
extern int maximum_dl;
extern int no_uses;
extern int no_ornode;
extern int no_andnode;
extern int no_factnode;
extern int no_ssnode;
extern int max_spt_count;
extern orlistptr delta_minus;

/*================================================================*/
/*                    Function Headers                            */
/*================================================================*/
extern VariantSF get_subgoal(ornodeptr);

/* From old slgsupport.h */
extern void inline add_answer_support(int, BTNptr);
extern void inline build_partial_setsupport(VariantSF);
extern void inline print_support(void);
extern void inline get_support(ornodeptr, BTNptr, int);
extern int mypower(int, int ); /* This is recursive, we can make it
				  faster using other methods like
				  Newton's, or repeated squaring */

/* From old tries.c */
extern void debugornode(ornodeptr);
extern void printssnode(setsupportnodeptr);
extern void prnt_statistics(void);
extern void printornode(ornodeptr);
extern void * allocate_a_chunk(void);
extern void inline * mymalloc(int);
extern void inline * mmalloc(int);
extern void myfree(void *);
extern void addpredtoornode(ornodeptr, andnodeptr);
extern void deletessnode(VariantSF);
extern void downfact(ornodeptr);
extern void mark_support(andnodeptr); 
extern void mark_setsupport_static(setsupportnodeptr);
extern void mark_setsupport_dynamic(setsupportnodeptr,ornodeptr);
extern void mark_answer(ornodeptr);
extern void get_trie_path(ornodeptr);
extern void deletion_phase(void);
extern void adjust(void);
extern void rederivation_phase(void);
extern void enque(orqptr, ornodeptr);
extern void deletion_phase(void);
extern void downfact(ornodeptr);
extern void mark_support(andnodeptr);
extern void mark_answer(ornodeptr);
extern void mark_setsupport_dynamic(setsupportnodeptr, ornodeptr);
extern void mark_setsupport_static(setsupportnodeptr);
extern void adjust(void);
extern void rederive_answer(ornodeptr);
extern void rederive_support(andnodeptr, int);
extern void rederive_setsupport_static(setsupportnodeptr, int);
extern void rederive_setsupport_dynamic(setsupportnodeptr, ornodeptr);
extern void rederivation_phase(void);
extern void rederive_answer(ornodeptr);
extern void rederive_support(andnodeptr, int);
extern void recalculate_parameters(ornodeptr, int);
extern void rederive_setsupport_dynamic(setsupportnodeptr, ornodeptr);
extern void rederive_setsupport_static(setsupportnodeptr, int);
extern int getmax(int, int);
extern int search_in_term(Cell, Cell, int *);
extern int contains_var(Cell);
extern ornodeptr makeornode(BTNptr);
extern ornodeptr find_reverse_mapping1(setsupportnodeptr, ornodeptr);
extern ornodeptr deque(orqptr);

extern setsupportnodeptr makesetsupportnode(VariantSF);
extern andnodeptr makeandnode(ornodeptr);
extern Cell get_symbol(ornodeptr);
extern orqptr initq(void);


/*================================================================*/
/*          Support Graph DataStructure Definitions               */
/*================================================================*/

typedef struct andnodetag {
  unsigned char falsecount;
  unsigned char dl;
  ornodeptr answer_of;
  andnodeptr next_andnode;
} AND_NODE;

typedef struct ornodetag {
  BTNptr leaf;
  setsupportlistptr set_uses_of;
  andlistptr uses_of;
  unsigned int dl:6;
  unsigned int total_support_count:15;
  unsigned int acyclic_support_count:10;
  andnodeptr support;
} OR_NODE;

/* Assumption that there can be only max 7 variables the answer
 * template of head can contain. We allocate only 21bits for that.
 */  

typedef struct setsupportnodetag {
  unsigned int maplen:3;
  unsigned int map:21;
  unsigned int static_falsecount:2;
  unsigned int static_maxdl:6;
  void * dynamic_answer_subg;
  void * answer_of_subg; 
} SET_SUPPORT_NODE;

typedef struct _andlist {
  andnodeptr item;
  andlistptr next;
} ANDLIST;

typedef struct _setsupportlist {
  setsupportnodeptr item;
  setsupportlistptr next;
} SETSUPPORTLIST;

typedef struct _orlist {
  ornodeptr item;
  orlistptr next;
} ORLIST;

typedef struct _element {
  ornodeptr item;
  elementptr next;
} ELEMENT;

typedef struct _orq {
  elementptr head;
  elementptr tail;
} ORQ;
