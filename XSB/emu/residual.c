/* File:      residual.c
** Author(s): Kostis Sagonas, Baoqiu Cui
** Contact:   xsb-contact@cs.sunysb.edu
** 
** Copyright (C) The Research Foundation of SUNY, 1986, 1993-1998
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
** $Id: residual.c,v 1.2 1998-12-09 03:14:37 cbaoqiu Exp $
** 
*/


#include <stdio.h>

#include "configs/config.h"
#include "debugs/debug.h"


/* special debug includes */
#include "debugs/debug_residual.h"

#include "auxlry.h"
#include "cell.h"
#include "psc.h"
#include "register.h"
#include "heap.h"
#include "binding.h"
#include "tries.h"
#include "xmacro.h"

/*----------------------------------------------------------------------*/

#ifdef DEBUG_RESIDUAL
extern void print_subgoal(FILE *, SGFrame);
#endif

/*----------------------------------------------------------------------*/

static Cell cell_array[500];

/*----------------------------------------------------------------------*/

#define build_subgoal_args(SUBG)	\
	load_solution_trie(arity, &cell_array[arity-1], subg_leaf_ptr(SUBG))


CPtr *copy_of_var_addr;
int copy_of_num_heap_term_vars;

/*----------------------------------------------------------------------*/

/*
 * Function build_delay_list() is called by builtin #143 GET_DELAY_LISTS
 * to construct on the heap the delay list pointed by `de'.  Since XSB
 * 1.8.1, this function is changed to handle variables in delay list.
 * Basically, to construct a delayed subgoal, we have to go through three 
 * tries one by one: the call trie, answer trie, and delay trie of the
 * delayed subgoal.  Delay trie contains the substitution factor of the
 * answer for the delayed subgoal.
 */

void build_delay_list(CPtr delay_list, DE de)
{
  Psc  psc;
  int  i, j, arity;
  CPtr head, tail;
  SGFrame subg;
  NODEptr ans_subst;
  NODEptr subs_factp;		/* new vars */
  CPtr *tmp_var_addr;
  CPtr oldhreg = hreg;
 
 
#ifdef HEAP_DEBUG
    fprintf(stderr, "delay_list starts at %p\n", hreg);
#endif
    i = 0;
    if (de != NULL && !isnil(de)) {
 
      tail = hreg+1;
      bind_list(delay_list, hreg);
      hreg = hreg + 3; 
      build_delay_list(tail, de_next(de)); /* recursive call */
      head = hreg;
      subg = de_subgoal(de);
      psc = ti_psc_ptr(subg_tip_ptr(subg));
      arity = get_arity(psc);
      if ((ans_subst = de_ans_subst(de)) == NULL) { /* Negative DE */
        follow(oldhreg) = makecs(hreg);
        new_heap_functor(head, tnot_psc);
        if (arity == 0) {
          bind_string(head, get_name(psc));
          hreg += 3;
        } else {
          sreg = head+1;
          follow(head++) = makecs(sreg);
          hreg += arity+4; /* need arity(tnot)+2+arity(psc)+1 new cells */
          new_heap_functor(sreg, psc);
          for (j = 1; j <= arity; j++) {
            new_heap_free(sreg);
            cell_array[arity-j] = cell(sreg-1);
          }
          build_subgoal_args(subg);
        }
      } else {					/* Positive DE */
        if (arity == 0) {
          new_heap_string(oldhreg, get_name(psc));
        } else {
	  /*
	   * de_subs_fact(de) is the saved substitution factor for the
	   * call of this delayed element.
	   */
          subs_factp = (NODEptr)de_subs_fact(de);
          sreg = head;
          follow(oldhreg) = makecs(head);
          hreg += arity+1;
          new_heap_functor(sreg, psc);
          for (j = 1; j <= arity; j++) {
            new_heap_free(sreg);
            cell_array[arity-j] = cell(sreg-1);
          }

#ifdef DEBUG_DELAYVAR
	  fprintf(stderr, ">>>> (before build_subgoal_args) num_heap_term_vars = %d\n", num_heap_term_vars);
#endif

	  /*
	   * Function build_subgoal_args() goes through the subgoal trie
	   * and binds all the arguments of the subgoal skeleton, which
	   * were built in the heap (like q(_,_)), to the actual call
	   * arguments (like X and f(Y,g(Z)) in q(X, f(Y,g(Z)))).
	   *
	   * After build_subgoal_args, var_addr[] contains all the
	   * variables in the subgoal call.
	   */
	  build_subgoal_args(subg);

#ifdef DEBUG_DELAYVAR
	  fprintf(stderr, ">>>> (after build_subgoal_args) num_heap_term_vars = %d\n", num_heap_term_vars);
#endif
	  
          for (i = 0, j = num_heap_term_vars-1; j >= 0; j--) {
            cell_array[i++] = (Cell)var_addr[j];
#ifdef DEBUG_DELAYVAR
	    fprintf(stderr, ">>>> var_addr[%x] = %x\n", j, (int)var_addr[j]);
#endif
          }

	  /*
	   * Function load_solution_trie() goes through the answer trie
	   * and binds the call substitution factor.  The substitution
	   * factor of the answer is left in var_addr[].
	   */
	  load_solution_trie(i, &cell_array[i-1], ans_subst);

#ifdef DEBUG_DELAYVAR
	  fprintf(stderr, ">>>> (after load_solution_trie) num_heap_term_vars = %d\n", num_heap_term_vars);
#endif

	  for (i = 0, j = num_heap_term_vars-1; j >= 0; j--) {
            cell_array[i++] = (Cell)var_addr[j];
#ifdef DEBUG_DELAYVAR
	    fprintf(stderr, ">>>> var_addr[%x] = %x\n", j, (int)var_addr[j]);
#endif
          }

          tmp_var_addr = var_addr;

	  /*
	   * Restore var_addr[] to copy_of_var_addr[], which contains all
	   * the variables in the _head_ predicate after get_returns is
	   * called (see bineg.i).
	   *
	   * The content of copy_of_var_addr[] is used in
	   * load_delay_trie(), and might be changed by each delay
	   * element.  But during the whole process for one paticular
	   * delay list, copy_of_var_addr[] will be shared by all the
	   * delay elements.
	   *
	   * It is not necessary to restore copy_of_num_heap_term_vars
	   * each time before load_delay_trie() is called for a delay
	   * element.  Each variable in the trie can find its binding in
	   * copy_of_var_addr[] without num_heap_term_vars.
	   */
	  var_addr = copy_of_var_addr; /* variables left in the head */
          num_heap_term_vars = copy_of_num_heap_term_vars;


#ifdef DEBUG_DELAYVAR
	  fprintf(stderr, ">>>> NOW copy_of_num_heap_term_vars = %d\n",
		  copy_of_num_heap_term_vars);
          {
            int i;
            for(i = 0; i < num_heap_term_vars; i++)
              fprintf(stderr, ">>>> var_addr[%d] = %x\n",i, (int)var_addr[i]);

            fprintf(stderr, "Stored Subs Fact: <");
            {
              NODEptr x = subs_factp;
	      if (x == NULL) fprintf(stderr, ">>>> subs_factp is NULL\n");
              while(x != NULL){
                print_trie_atom(Atom(x));
                if(Sibl(x) != NULL) fprintf(stderr, "!");
                x = Child(x);
 
              }
            }
            fprintf(stderr, ">\n");
          }
	  fprintf(stderr, ">>>> num_heap_term_vars is %d before calling load_delay_trie\n", num_heap_term_vars);
#endif /* DEBUG_DELAYVAR */
	  
          load_delay_trie(i, &cell_array[i-1],(NODEptr)de_subs_fact_leaf(de));

#ifdef DEBUG_DELAYVAR
	  fprintf(stderr, ">>>> num_heap_term_vars becomes %d\n",
		  num_heap_term_vars);
	  for (i = 0; i < num_heap_term_vars; i++)
	    fprintf(stderr, ">>>> var_addr[%d] = %x\n",i, (int)var_addr[i]);
#endif
          var_addr = tmp_var_addr;
        }
      }
      hreg++;
    } else {
      bind_nil(delay_list);
    }
}

/*---------------------- end of file residual.c ------------------------*/
