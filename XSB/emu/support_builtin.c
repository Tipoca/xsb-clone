/* File:      support_builtin.c
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
/* Same includes as incr_xsb.c */
#include "xsb_config.h"
#include "xsb_debug.h"

#include <stdio.h>
#include <stdlib.h>

#include "auxlry.h"
#include "context.h"
#include "cell_xsb.h"
#include "psc_xsb.h"
#include "cinterf.h"
#include "deref.h"
#include "memory_xsb.h"
#include "heap_xsb.h"
#include "register.h"
#include "tries.h"
#include "trie_internals.h"
/* #include "macro_xsb.h" --depricated */
#include "tab_structs.h"
#include "choice.h"
#include "subp.h"
#include "error_xsb.h"
#include "tr_utils.h"
#include "incr_xsb.h"
#include "debug_xsb.h"
#include "flags_xsb.h"
#include "ptoc_tag_xsb_i.h"
#include "call_graph_xsb.h"
#include "term_psc_xsb_i.h"
#include "rw_lock.h"
#include "token_xsb.h"
#include "binding.h"
#include "tst_utils.h"

/*
#include "xsb_config.h"
#include "xsb_debug.h"
#include "debugs/debug_delay.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <signal.h>
#include <math.h>

#ifdef WIN_NT
#include <windows.h>
#include <direct.h>
#include <io.h>
#include <process.h>
#include <stdarg.h>
#include <winsock.h>
#include "wsipx.h"
#include <tchar.h>
#else 
#include <unistd.h> 
#include <sys/socket.h>
#include <sys/uio.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#endif
#include <fcntl.h>
#include "auxlry.h"
#include "context.h"
#include "cell_xsb.h"
#include "error_xsb.h"
#include "psc_xsb.h"
#include "hash_xsb.h"
#include "tries.h"
#include "choice.h"
#include "deref.h"
#include "memory_xsb.h"
#include "heap_xsb.h"
#include "register.h"
#include "flags_xsb.h"
#include "loader_xsb.h"
#include "binding.h"
#include "macro_xsb.h"
#include "builtin.h"
#include "sig_xsb.h"
#include "subp.h"
#include "tr_utils.h"
#include "trassert.h"
#include "dynload.h"
#include "cinterf.h"
#include "residual.h"
#include "tables.h"
#include "trie_internals.h"
#include "table_status_defs.h"
#ifdef ORACLE
#include "oracle_xsb.h"
#endif
#ifdef XSB_ODBC
#include "odbc_xsb.h"
#endif
#ifdef XSB_INTERPROLOG
#include "interprolog_xsb.h"
#endif
#ifdef PROFILE
#include "inst_xsb.h"
#include "subinst.h"
#endif
#include "io_builtins_xsb.h"
#include "storage_xsb.h"
#include "wind2unix.h"
#include "system_xsb.h"
#include "random_xsb.h"
#ifdef DEMAND
#include "demand.h"
#endif
#include "debug_xsb.h"
#include "ptoc_tag_xsb_i.h"
*/

/*
 *  For decoding object pointers, like PSC, PSC-PAIR and Subgoal frames.
 */
#define ptoc_addr(regnum)	(void *)ptoc_int(CTXTc regnum)
#define is_encoded_addr(term)	isinteger(term)
#define decode_addr(term)	(void *)oint_val(term)

/* Psudo-builtins assigned numbers go here. We only include builtins
 * that actually have code in builtin.c, and keep the names as defined
 * by Dipti in the original implementation of Support Graphs
 */
#include "support_builtin.h"

/*
#define INCR_ASSERT	    0
#define RETURN_E            1
#define SET_MODE            2
#define GET_DIRTY_COUNT     3
#define UPDATE              4
#define ENTER_DELTA_MINUS   5
#define FAST_TRIE_INTERN    6
#define GET_MODE            7
#define INCR_TRIE_DISPOSE   8
*/

/* Arg 1 is the OP code. The rest are real arguments to the builtin 
 * Code is copied directly from builtin.c of the original
 * implementation of Support Graphs
 */

xsbBool support_builtin(CTXTdecl)
{
  int builtin_number = ptoc_int(CTXTc 1);
  printf("builtin_number = %d\n", builtin_number);

  switch (builtin_number) {
      case INCR_ASSERT: {
	printf("Incr assert: builtin_number = %d\n", builtin_number);
    if (increm_assert())
      return TRUE;
    else
      xsb_exit("Faillure of increm_assert/1");
    break;
    }

  case RETURN_E: {
    Cell ret;
    BTNptr leaf,root=NULL;
    VariantSF sf = get_call(ptoc_tag(2), &ret);
    
    printf("1\n");
    if ( IsNonNULL(sf) && IsNonNULL(sf->base_sf)) {
      printf("2\n");
      leaf=ALN_Answer(subg_answers(sf));
      printf("3\n");
      bottomupunify(ptoc_tag(3), root, leaf);
      printf("4\n"); 
    }
    break;
  }

  case SET_MODE: {
    printf("hello set_mode\n");
    support_mode=ptoc_int(CTXTc 1);
    break;
  }

  case GET_DIRTY_COUNT: {
    int dirty_count = 0;
    /* Don't know if regCallTerm should be 2 as before or 3 as per the
    changes for pseudo-builtins */
    const int regCallTerm = 3;   /* in:  tabled call to look for */
    VariantSF sf;
    
    sf = get_dirty_count(ptoc_tag(regCallTerm), &dirty_count);
    if ( IsNonNULL(sf) ) {
      ctop_int(CTXTc 3,dirty_count);
    }
    break;
  }
    
  case UPDATE: {
    printf("working?");
    dred();
    break;
    }

  case ENTER_DELTA_MINUS: {
    const int regTableEntry = 2;  
    VariantSF sf;
    ornodeptr ornode;
    BTNptr ans_root_ptr = subg_ans_root_ptr(sf);

    printf("Entering delta minus\n");
    sf = ptoc_addr(regTableEntry);
    if (IsNULL(ans_root_ptr) )
      return (byte *)&fail_inst;
    /* assuming that for  mynot predicate which have answer one entry
       in the answer table as it was ground thus we need to get the ornode
       corresponding to this answer
    */
    
    ornode = (ornodeptr)sf->dirty_count;
    if(ornode!=NULL){
      orlistptr ptrorlist=malloc(sizeof(struct _orlist));
      ptrorlist->item = ornode;
      ptrorlist->next = delta_minus;
      delta_minus = ptrorlist;
      /* delete the trie branch from the mynot table */
      delete_branch(ornode->leaf,&subg_ans_root_ptr(sf),VARIANT_EVAL_METHOD); }
    break;
  }

  case FAST_TRIE_INTERN: {
    fast_intern(ptoc_tag(1));
    break;
  }

  case GET_MODE: {
    int no_regs = ptoc_int(CTXTc 2),maplen = 0,map = 0,temp;
    Cell term = ptoc_tag(3);
    int sm,template_size, attv_num, tmp;
    CPtr producer_cpf, answer_template;
    VariantSF producer_sf;
    
    producer_sf = (VariantSF)cell(ereg-no_regs); 
    producer_cpf = subg_cp_ptr(producer_sf);
    answer_template = tcp_template(producer_cpf);
    tmp = int_val(cell(answer_template));
    get_var_and_attv_nums(template_size, attv_num, tmp);
    answer_template--;
    sm=1;
    
    if(contains_var(term)){
      int i;
      Cell c;
      
      if (template_size > 0) {
	sm=3;
	maplen=template_size;

	for (i = 0; i < template_size; i++) {
	  c=*answer_template;
	  printderef(c);
	  
	  if(!((cell_tag(c)==XSB_FREE)||(cell_tag(c)==XSB_REF1))){	 
	    sm=1; }	   
	  else {
	    if(search_in_term(term,c,&temp))
	      map += mypower(2,3*i)*temp; 
	      /* 3 bits allocated for each variable positions */
	  }
	  answer_template--;
	}
      }
      else {
	maplen=0;
	sm = 2;
      }
    }
    
    support_mode = sm;
    ctop_int(4,sm);
    
    if(sm>1) {
      /* create variable map */
      build_partial_setsupport(producer_sf);
      current_ssn->map=map;
      current_ssn->maplen=maplen; }
#ifdef DIPTI_DEBUG
    printf("out of get mode %d ", sm);
#endif
    break;
  }

  case INCR_TRIE_DISPOSE: {
    incr_trie_dispose();
    break;
  }
  }
}



/* To use these bultins, you must have a .P file with the following
 * information: 
 * I think instead of '1' in each case, we should pass the appropriate
 * pseudo-builtin defined number, like '1' for 'print_ls', '2' for
 * 'print_tr' e.t.c. --spyros
 */
  
/*
print_ls :- private_builtin(1,_,_,_,_,_,_,_,_,_,_).
print_tr :- private_builtin(1,_,_,_,_,_,_,_,_,_,_).
print_heap :- private_builtin(1,_,_,_,_,_,_,_,_,_,_).
print_cp :- private_builtin(1,_,_,_,_,_,_,_,_,_,_).
print_regs :- private_builtin(1,_,_,_,_,_,_,_,_,_,_).
print_all_stacks :- private_builtin(1,_,_,_,_,_,_,_,_,_,_).
exp_heap :- private_builtin(1,_,_,_,_,_,_,_,_,_,_).
mark_heap(A) :- private_builtin(1,A,_,_,_,_,_,_,_,_,_).
gc_heap :- private_builtin(1,_,_,_,_,_,_,_,_,_,_).
*/
