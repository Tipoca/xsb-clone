/* File:      support.c
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

#include "xsb_config.h"
#include "xsb_debug.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "context.h"
/* Special debug includes */
#include "debugs/debug_tries.h"
#include "debug_xsb.h"
#include "auxlry.h"
#include "cell_xsb.h"
#include "inst_xsb.h"
#include "psc_xsb.h"
#include "heap_xsb.h"
#include "flags_xsb.h"
#include "deref.h"
#include "memory_xsb.h"
#include "register.h"
#include "binding.h"
#include "trie_internals.h"
/* #include "macro_xsb.h" --depricated */
#include "tab_structs.h"
#include "choice.h"
#include "cinterf.h"
#include "error_xsb.h"
#include "tr_utils.h"
#include "hash_xsb.h" 
#include "cell_xsb.h"
#include "call_xsb_i.h"
#include "tst_aux.h"
#include "token_xsb.h"

/* Support Graph Headers */
//#include "support.h"
//#include "call_graph_xsb.h"

/* Comment-out for debugging purposes */
#define DIPTI_ASSERTION
#define NO_OF_CHUNK 600
#define CHUNK_SIZE 2000000
Psc support_psc;

/*================================================================*/
/*                Variables Needed (old tries.c)                  */
/*================================================================*/

char gstr[1000000]; /* Why such a big table? */
int no_marked = 0;
int no_red = 0;

setsupportnodeptr current_ssn;
orlistptr delta_minus = NULL;
orlistptr delta_plus = NULL;
orlistptr delta_assumption = NULL;
orlistptr ornodestore = NULL;
setsupportlistptr ssstore = NULL;

int max_dl = 0;
int support_mode = 1;
int print_sg = 1;
int no_ornode = 0;
int no_andnode = 0;
int no_factnode = 0;
int no_uses = 0; 
int no_ssnode = 0; 
int max_spt_count = 0;
int total_allocated = 0;

void * mem_chunk[NO_OF_CHUNK];
void * p;
int mmsize = CHUNK_SIZE;
int current_chunk = -1;

int anslen;
CPtr heap_area;
Cell cellarr[8];

orqptr delq;
orqptr redq;

/*================================================================*/
/*                    Function Definitions                        */
/*================================================================*/
/*
void bottomupunify(Cell term, BTNptr Root, BTNptr Leaf)
{
  CPtr Dummy_Addr;
  Cell returned_val, xtemp2;
  CPtr gen;
  int  i;

  num_heap_term_vars = 0;     
  follow_par_chain(Leaf);
  
  XSB_Deref(term);
  
  gen = (CPtr) term;
  
  macro_make_heap_term(gen,returned_val,Dummy_Addr);
  bld_ref(gen,returned_val);
  
  for(i = 0; i < num_heap_term_vars; i++){
    var_regs[i] = var_addr[i];
  }
  global_num_vars = num_vars_in_var_regs = num_heap_term_vars - 1;
  Last_Nod_Sav = Leaf;
}
*/

/* Code from old slgsupport.h */
void inline add_answer_support(int i,BTNptr myleaf)
{ 
  Cell cons_cell;
 
  cons_cell = makelist(hreg);
  sreg = hreg + 2;
  follow(hreg++) = makecs(sreg);
  follow(hreg++) = (supreg == NULL ? makenil : (Cell) supreg);
  new_heap_functor(sreg,support_psc);
  cell(sreg++) = makeint(0);
  cell(sreg++) = makeaddr(myleaf);
  hreg = sreg;
  supreg = (CPtr) cons_cell;
}
    
void inline build_partial_setsupport(VariantSF subg)
{
  BTNptr pLeaf;
  CPtr sup = supreg;
  CPtr cptr;
  int count=0;
  CPtr tmp;
  ornodeptr ans;
  setsupportnodeptr ssn;
  setsupportlistptr temp, set_uses_of_static;
  int maxdl = -1;
  
  if (sup == NULL) {
    /* static part is null */
    ssn=makesetsupportnode(subg);
    ssn->static_maxdl=0;
    current_ssn=ssn;
  } 
  else {
    if (islist(sup) || isnil(sup)) {
      ssn=makesetsupportnode(subg);
      cptr = sup;
      while (islist(cptr)) {
	cptr = clref_val(cptr);
	tmp = clref_val(cell(cptr));
	tmp = tmp + 2;	
	pLeaf = (BTNptr) addr_val(cell(tmp));
	if (IsNonNULL(pLeaf->ornode)){
	  ans=pLeaf->ornode;
	  if (ans->dl>maxdl)
	    maxdl=ans->dl;
	  temp=ans->set_uses_of;
	  set_uses_of_static=(setsupportlistptr)mymalloc(sizeof(struct _setsupportlist));
	  set_uses_of_static->next=temp;
	  set_uses_of_static->item=ssn;
	  ans->set_uses_of=set_uses_of_static;
	}
	else {
	  printf("ERROR :pLeaf->ornode is null:");
	}
	cptr = (CPtr) cell(cptr+1);
      }
      ssn->static_maxdl=maxdl;
      /* for statistics */
      if (maxdl>max_dl)
	max_dl=maxdl;
      current_ssn=ssn;
    } 
    else {
      xsb_abort("Support list is not a list (at all)!!!\n");
    }
  }
}


void inline print_support(void)
{
   BTNptr pLeaf;
   CPtr sup = supreg;
   CPtr cptr;
   int count=0;
   CPtr tmp;
   orlistptr ptrorlist = NULL, temp, next;
   andnodeptr ptrandnode;

   if (sup == NULL) {
   } 
   else {
     if (islist(sup) || isnil(sup)) {
       cptr = sup;
       while (islist(cptr)) {
	 cptr = clref_val(cptr);
	 tmp = clref_val(cell(cptr));
	 tmp = tmp + 2;	
	 pLeaf = (BTNptr) addr_val(cell(tmp));
	 if(IsNonNULL(pLeaf->ornode)){
	   printornode(pLeaf->ornode);
	 }
	 else {
	   printf("ERROR :pLeaf->ornode is null:");
	 }
	 cptr = (CPtr) cell(cptr+1);
       }
     } 
     else {
       xsb_abort("Support list is not a list (at all)!!!\n");
     }
   }
}

void inline get_support(ornodeptr orpred,BTNptr aot,int new)
{
  BTNptr pLeaf;
  CPtr sup = supreg;
  CPtr cptr;
  int count = 0;
  int maxdl = -1;
  CPtr tmp;
  orlistptr ptrorlist = NULL, temp, next;
  andnodeptr ptrandnode;

  if(support_mode==1) {
    if (sup == NULL) {
    }
    else {
      if (islist(sup) || isnil(sup)) {
	cptr = sup;
	ptrandnode=makeandnode(orpred);
	while (islist(cptr)) {
	  cptr = clref_val(cptr);
	  tmp = clref_val(cell(cptr));
	  tmp = tmp + 2;	
	  pLeaf = (BTNptr) addr_val(cell(tmp));	
	  if(IsNonNULL(pLeaf->ornode)){
	    addpredtoornode(pLeaf->ornode,ptrandnode);
	    if(pLeaf->ornode->dl>maxdl)
	      maxdl=pLeaf->ornode->dl;
	  }
	  else { 
	    printf("ERROR :pLeaf->ornode is null:");
	  }
	  cptr = (CPtr) cell(cptr+1);
	}
	ptrandnode->dl=maxdl+1;
	if (maxdl+1>max_dl)
	  max_dl=maxdl+1;
	if (new)
	  orpred->dl=ptrandnode->dl;
	if (orpred->dl>=ptrandnode->dl){
	  orpred->acyclic_support_count++;
	}  
      } 
      else {
	xsb_abort("Support list is not a list (at all)!!!\n");
      }
    }
  }
  else {
    if (sup == NULL) {
    } 
    else {
      if (islist(sup) || isnil(sup)) {
	cptr = sup;
	orpred->total_support_count++;
	while (islist(cptr)) {
	  cptr = clref_val(cptr);
	  tmp = clref_val(cell(cptr));
	  tmp = tmp + 2;	
	  pLeaf = (BTNptr) addr_val(cell(tmp));	
	  if (IsNonNULL(pLeaf->ornode)){
	    if (pLeaf->ornode->dl>maxdl)
	      maxdl=pLeaf->ornode->dl;
	  }
	  else { 
	    printf("ERROR :pLeaf->ornode is null:");
	  }
	  cptr = (CPtr) cell(cptr+1);
	}
	if (new)
	  orpred->dl=maxdl+1;
	if (orpred->dl>=maxdl+1){
	  orpred->acyclic_support_count++;
	}  
	if(max_dl<maxdl+1)
	  max_dl=maxdl+1;
      } 
      else {
	xsb_abort("Support list is not a list (at all)!!!\n");
      }
    }
  }
}

/* This can be implemented more efficiently */
int mypower(int base,int exponent) 
{
  if (exponent == 0)
    return 1;
  else
    if (exponent == 1)
      return base;
    else
      return (base * mypower(base, exponent-1));
}

int search_in_term(Cell term, Cell c, int *p)
{
  int flag = 0;
  CPtr cptr;
  
  printderef(term);
  
  switch(cell_tag(term)) {
  case XSB_FREE:
  case XSB_REF1: {
    *p=1;
    if (compare(term,c)==0) {
      flag = 1;
    }
    else {
      flag = 0;
    }
    return flag;
    break;  
  }
  case XSB_LIST:{
    int x,y;
    cptr = clref_val(term);
    if (search_in_term(cell(cptr),c,&x)) {
      *p=x;
      return 1;
     } 
    else {
      if (search_in_term(cell(cptr+1),c,&y)) {
	*p=y+x;
	return 1;
      }
      else {
	*p=y+x;
	return 0;
      }
    }
    break;   
  }   
  case XSB_STRUCT:{
    int x;
    int i, y, arity = get_arity(get_str_psc(term));

    if ( arity == 0 ) {
      *p=0;
      return 0;
    }
    cptr = clref_val(term);
    x=0;

    for ( i = 1; i <= arity; i++ ) {
      if(search_in_term(cell(cptr+i),c,&y)){
	*p=x+y;
	return 1;
      } 
      else{
	x+=y;	
      }
    }
    *p=x;
    return 0;
  }
  default:
    *p=0;
    return 0;
  }
  return flag;
}

int contains_var(Cell term)
{
  int flag=0;
  CPtr cptr;
  
  printderef(term);

  switch (cell_tag(term)) {
  case XSB_FREE:
  case XSB_REF1: flag = 1; break;  
  case XSB_LIST:
    cptr = clref_val(term);
    flag= contains_var(cell(cptr)) || contains_var(cell(cptr+1));
    break;   
  case XSB_STRUCT:{
    int i,arity = get_arity(get_str_psc(term));
    if ( arity == 0 )   /* constant */
      break;
    /* structure */
    cptr = clref_val(term);
    for ( i = 1; i <= arity; i++ ) {
      if (contains_var(cell(cptr+i))) { 
	flag=1;
	  break;
      }
    }
  } 
  }
  return flag;
}

VariantSF get_subgoal(ornodeptr ans)
{
   BTNptr pLeaf=ans->leaf;
   while (IsNonNULL(pLeaf) && !IsTrieRoot(pLeaf)) {
     pLeaf = BTN_Parent(pLeaf);
   }
   if(!((IsNonNULL(pLeaf)&&IsTrieRoot(pLeaf)))){     
     xsb_abort("get_subgoal:Trie Root Not Found\n");
     return NULL; 
   }
   else
     return pLeaf->parent;
}


/* Code from old tries.c */

/*================================================================*/
/*                        Some Statistics                         */
/*================================================================*/

void debugornode(ornodeptr ans) 
{
  printornode(ans);
  printf("**info dl=%d, tsc=%d, asc=%d\n",ans->dl,ans->total_support_count,
	ans->acyclic_support_count);
}

void printssnode(setsupportnodeptr ss)
{
  sfPrintGoal(stdout,ss->answer_of_subg,NO);
  sfPrintGoal(stdout,ss->dynamic_answer_subg,NO);
}

void prnt_statistics()
{
  printf("\nfactnode=%d\n answernode=%d\n,supportnode=%d\n,uses %d\n, ssnode %d\n",no_factnode,no_ornode,no_andnode,no_uses,no_ssnode);
  printf("\ntotal allocated memory %d",total_allocated);
  printf("\nal=%d or %d and %d\n",sizeof(struct setsupportnodetag),sizeof(struct ornodetag),sizeof(struct andnodetag));
  printf("maximum dl %d\n",max_dl);

  total_allocated = 0;

  #ifdef DIPTI_DEBUG      
    orlistptr temp;
    temp=ornodestore;
    while(temp!=NULL){
      if(temp->item->dl!=0)
	debugornode(temp->item);
      temp=temp->next;
    }
    setsupportlistptr ssl;
    ssl=ssstore;
    printf("\n");
    while(ssl!=NULL){
      printssnode(ssl->item);
      printf("\n");
      ssl=ssl->next;
    }
 #endif
}

void printornode(ornodeptr ans)
{
  VariantSF subg = get_subgoal(ans);

  if(subg!=NULL){
    printf("goal(");
    sfPrintGoal(stdout,subg,NO);printf(",");
    printTriePath(stdout,ans->leaf,NO);
    printf(") ");
  }
  else
    printTriePath(stdout,ans->leaf,NO);
}


/*================================================================*/
/*                      A small memory manager                    */
/*================================================================*/

void * allocate_a_chunk()
{
  return malloc(sizeof(char)*CHUNK_SIZE);
}

inline void *mmalloc(int size)
{
  int temp = mmsize + size;

  if(temp<CHUNK_SIZE){
    p=mem_chunk[current_chunk]+mmsize;
    mmsize=temp;
    return p;
  }
  else{
    mem_chunk[++current_chunk]=allocate_a_chunk();
    mmsize=size;
    return  mem_chunk[current_chunk];
  }
}

inline void * mymalloc(int size)
{
  total_allocated+=size;
  return mmalloc(size);
}

void myfree(void * f)
{
  total_allocated-=sizeof(f);
}

/*================================================================*/
/*                   Generation of Support Graph                  */
/*================================================================*/

ornodeptr makeornode(BTNptr leafnode)
{
  ornodeptr ornodeptr1;

  ornodeptr1 = (ornodeptr)mymalloc(sizeof(struct ornodetag));
  if(ornodeptr1!=NULL){
    ornodeptr1->leaf=leafnode;
    ornodeptr1->uses_of=NULL;
    ornodeptr1->support=NULL;
    ornodeptr1->set_uses_of=NULL;
    ornodeptr1->total_support_count=0;
    ornodeptr1->acyclic_support_count=0;
    ornodeptr1->dl=0;
  }
#ifdef DIPTI_DEBUG       
  orlistptr  temp;
  temp=ornodestore;
  ornodestore=(orlistptr)malloc(sizeof(struct _orlist));
  ornodestore->item=ornodeptr1;
  ornodestore->next=temp;  
#endif
  
  return ornodeptr1;
}

void addpredtoornode(ornodeptr ptrornode,andnodeptr ptrandnode)
{
  andlistptr temp;
  
  temp=ptrornode->uses_of;
  ptrornode->uses_of=mymalloc(sizeof(struct _andlist));
  ptrornode->uses_of->item=ptrandnode;
  ptrornode->uses_of->next= temp;
  no_uses++;
}

setsupportnodeptr makesetsupportnode(VariantSF subg)
{
  setsupportnodeptr ptrssnode;
  ptrssnode=(setsupportnodeptr)mymalloc(sizeof(struct setsupportnodetag));

  if(ptrssnode!=NULL){
    ptrssnode->static_falsecount=0;
    ptrssnode->dynamic_answer_subg=NULL;
    ptrssnode->answer_of_subg=subg;
       
    setsupportlistptr temp; 

    temp=subg->rsslptr;        
    subg->rsslptr=(setsupportlistptr)mymalloc(sizeof(struct _setsupportlist));
    subg->rsslptr->item=ptrssnode;
    subg->rsslptr->next=temp;    
    no_ssnode++;
  }
  #ifdef DIPTI_DEBUG
  {
    printf("<%d>",no_ssnode);
    sfPrintGoal(stdout,subg,NO);
    printf("<%d>\n",no_ssnode);
 
    setsupportlistptr  temp;

    temp=ssstore;
    ssstore=(setsupportlistptr)malloc(sizeof(struct _setsupportlist));
    ssstore->item=ptrssnode;
    ssstore->next=temp;      
  }
  #endif
  
  return ptrssnode; 
}

andnodeptr makeandnode(ornodeptr pred)
{
  andnodeptr temp;
  andnodeptr ptrandnode=(andnodeptr)mymalloc(sizeof(struct andnodetag));
  ptrandnode->falsecount=0;
  ptrandnode->answer_of=pred;
  temp=pred->support;
  pred->support=ptrandnode;
  ptrandnode->next_andnode=temp;
  pred->total_support_count++;
  no_andnode++;
  
  return ptrandnode; 
}

void deletessnode(VariantSF subg)
{
  setsupportlistptr temp1,temp2,temp3,temp4;
  setsupportnodeptr ss;
  VariantSF subg1;
  
  temp1=subg->sslptr;

  while(temp1!=NULL){
    ss=temp1->item;
    #ifdef DIPTI_DEBUG
    {
      printf("deletiong ss node related to ");
      printssnode(ss);
      printf("\n");
    }
    #endif
    
    /* delete */
    subg1=ss->answer_of_subg;
    
    if(subg1->rsslptr!=NULL){      
      if(subg1->rsslptr->item==ss){
	temp4=subg1->rsslptr;
	subg1->rsslptr=temp4->next;
	myfree(temp4);
      }
      else{
	temp4=subg1->rsslptr;
	temp2=temp4->next;
	while(temp2!=NULL){
	  if(temp2->item==ss){
	    temp4->next=temp2->next;
	    myfree(temp2);
	    break;
	  }
	  else{
	    temp4=temp2;
	    temp2=temp4->next;
	  }
	}
      }      
    }
    no_ssnode--;
    ss->dynamic_answer_subg=NULL;
    myfree(ss);
    ss=NULL;
    temp3=temp1;
    temp1=temp1->next;
    myfree(temp3);
  }
  subg->sslptr=NULL;
}

/*================================================================*/
/*                         Deletion Phase                         */
/*================================================================*/

void get_trie_path(ornodeptr ans)
{
  /* return trie path in a term */
  int i=0;
  Cell xtemp2;
  BTNptr pLeaf=ans->leaf;

  while ( IsNonNULL(pLeaf) && (! IsTrieRoot(pLeaf)) ) {
    xtemp2=BTN_Symbol(pLeaf);
    switch( TrieSymbolType(xtemp2) ) {				
    case XSB_TrieVar: {
      bld_free(hreg);
      bld_copy(cellarr+i,hreg);
      hreg++;
      i++;break;
    }
    case XSB_INT:{
      bld_int(cellarr+i,DecodeTrieInteger(xtemp2));
      i++;break;
    }
    case XSB_STRING:{
      bld_string(cellarr+i,DecodeTrieString(xtemp2));
      
      i++;break;
    }
    default:
      xsb_abort("Symbols other than string, int and list");
    }
    pLeaf = BTN_Parent(pLeaf);
  }
  anslen=i;     
}

ornodeptr find_reverse_mapping1(setsupportnodeptr ss,ornodeptr targetans) 
{
  Psc psc;
  Cell ret_term,term;
  Cell callVars[10];  
  Pair pair,*search_ptr;
  int j;  
  int reversemap[7]={0,0,0,0,0,0,0};
  int i;
  int map=ss->map;
  char name[3];

  for(i=1;i<=ss->maplen;++i){
    int index=map%8;    
    if(index!=0){
      reversemap[index]=i-1;
    }
    map=map/8;
  }
  
  hreg=heap_area;
  get_trie_path(targetans); 
  strcpy(name,"ret");
  search_ptr = (Pair *)(symbol_table.table +
			hash(name,ss->maplen, symbol_table.size));
  pair = search(ss->maplen,name, search_ptr);
  
  ret_term = hreg;
  new_heap_functor(hreg, pair_psc(pair));
  
  for(i=1;i<=ss->maplen;++i){
    nbldval(cellarr[reversemap[i]]);
  }
  term=makecs(ret_term);  
#ifdef DIPTI_DEBUG      
  printf("\n");
  printterm(stdout,term,25);printf("\t");
  sfPrintGoal(stdout,ss->dynamic_answer_subg,NO);
#endif
  
  BTNptr leaf,parent=subg_ans_root_ptr(ss->dynamic_answer_subg);
  leaf=variant_trie_lookup(parent,ss->maplen,clref_val(term)+1,callVars);
  if(IsNULL(leaf)){
    return NULL;
  }
  else{    
    return leaf->ornode;
  }  
}

ornodeptr find_answer_of(setsupportnodeptr ss,ornodeptr sourceans)
{
  /* create a term for target trie path using ss->map and ss->maplen */
  Psc psc;
  Cell term;
  Cell callVars[10];
  Pair pair,*search_ptr;
  CPtr ret_term;
  char name[3];
  int i,j;
  
  if(ss->maplen>0) {
    hreg=heap_area;
    get_trie_path(sourceans);
    strcpy(name,"ret");
    search_ptr = (Pair *)(symbol_table.table +
			  hash(name,ss->maplen, symbol_table.size));
    pair = search(ss->maplen,name, search_ptr);
    ret_term = hreg;
    new_heap_functor(hreg, pair_psc(pair));
    
    int map=ss->map;  
    
    for(i=1;i<=ss->maplen;++i){
      int index=map%8;
      map=map/8;
      if(index==0){
	new_heap_free(hreg);      
      }else{
	nbldval(cellarr[anslen-index]);
      }
    }
    
    term=makecs(ret_term);  

#ifdef DIPTI_DEBUG
    printterm(stdout,term,100);printf("\n");
#endif    
    
    BTNptr leaf,parent=subg_ans_root_ptr(ss->answer_of_subg);
    leaf=variant_trie_lookup(parent,ss->maplen,clref_val(term)+1,callVars);
    if(IsNULL(leaf)){
      return NULL;
    }
    else{
      
      return leaf->ornode;
    }
  }
  else{
    /* maplen==0: get the ornode attached to the escape node in answer trie */
    BTNptr trieRoot=subg_ans_root_ptr(ss->answer_of_subg);
    if(IsNonNULL(BTN_Child(trieRoot))){
      return (BTN_Child(trieRoot))->ornode;
    }
    else
      return NULL;
  }
}

Cell get_symbol(ornodeptr ans)
{
  BTNptr leaf=ans->leaf;
  #ifdef DIPTI_DEBUG
    printTrieSymbol(stdout,BTN_Symbol(leaf)); 
  #endif
  return BTN_Symbol(leaf);  
}

/*================================================================*/
/*                   The actual DReD Algorithm                    */
/*================================================================*/

void dred()
{
  heap_area=hreg;
  printf("\n--------DELETION PHASE--------------\n");
  double del_start=cpu_time();
  deletion_phase();
  double del_end=cpu_time();
  printf("Time Taken: %f, No of Marked %d\n\n",del_end-del_start,no_marked);
  
  
  adjust();
  double adjust_end=cpu_time();
  printf("adjust_time(%f).\n",adjust_end-del_end);
  no_red=0;

  
  printf("\n--------REDERIVATION PHASE--------------\n");
  rederivation_phase();
  printf("Time Taken to rederive: %f, No of answers rederived %d\n",cpu_time()-adjust_end,no_red);
  printf("del_time(%f).\n",cpu_time()-del_start);
}

orqptr initq()
{
    orqptr orq;
    orq=(orqptr)mmalloc(sizeof(struct _orq));
    orq->head=orq->tail=(elementptr)mmalloc(sizeof(struct _element));
    orq->head->next=orq->head->item=NULL;  
    return orq;
}

ornodeptr deque(orqptr orq)
{
  if(orq->head==orq->tail)
    return NULL;
  elementptr temp=orq->tail;
  orq->tail=orq->tail->next;

  return orq->tail->item;  
}

void enque(orqptr orq,ornodeptr ans)
{
  elementptr new=(elementptr)mmalloc(sizeof(struct _element)); 
  new->item=ans;
  orq->head->next=new;
  orq->head=new;    
}

void deletion_phase()
{
  orlistptr ptr,next;
  ornodeptr ornode;

  delq=initq();
  no_marked=0;

  for(ptr=delta_minus;IsNonNULL(ptr);ptr=next){
    next=ptr->next;
    ornode=ptr->item;
    downfact(ornode);    
    free(ptr);
  }

  while((ornode=deque(delq))!=NULL)
    mark_answer(ornode); 
}

void downfact(ornodeptr ptrfactnode)
{
  andlistptr temp=ptrfactnode->uses_of;
  andlistptr next;

  while(temp!=NULL){
    next=temp->next;
    mark_support(temp->item);    
    temp=next;    
  }

  setsupportlistptr setuses=ptrfactnode->set_uses_of;
  setsupportlistptr tempsetuses;

  while(setuses!=NULL){
    tempsetuses=setuses->next;
    mark_setsupport_static(setuses->item);    
    setuses=tempsetuses;
  }
  myfree(ptrfactnode);  
}

void mark_support(andnodeptr s)
{
  ornodeptr ans=s->answer_of;

  if(ans!=NULL){
    s->falsecount++;
    if(s->falsecount==1){
      ans->total_support_count--;
      if(ans->dl>=s->dl){
	ans->acyclic_support_count--;
	if(ans->acyclic_support_count==0)
	  enque(delq,ans);
      }
    }
  }  
}

void mark_answer(ornodeptr ans)
{
  safe_delete_branch(ans->leaf);
  no_marked++;
  
  VariantSF subg;
  Cell *sym;

  if(ans->total_support_count>0){
    orlistptr ptrorlist1=(orlistptr)malloc(sizeof(struct _orlist));
    ptrorlist1->item = ans;
    ptrorlist1->next = delta_assumption;     
    delta_assumption = ptrorlist1;
  }

  andlistptr andlist=ans->uses_of;
  while(andlist!=NULL){
    mark_support(andlist->item);
    andlist=andlist->next;
  }

  setsupportlistptr sslist=ans->set_uses_of;
  while(IsNonNULL(sslist)&&(IsNonNULL(sslist->item))){
    mark_setsupport_static(sslist->item);
    sslist=sslist->next;
  }
  
  subg=get_subgoal(ans);
  sslist=subg->sslptr;
  while(sslist!=NULL){
    mark_setsupport_dynamic(sslist->item,ans);
    sslist=sslist->next;
  }
}

int getmax(int a,int b)
{
  if(a>b)
    return a;
  else
    return b;
}

void mark_setsupport_dynamic(setsupportnodeptr ss,ornodeptr sans)
{
  ornodeptr ans;  

  if(ss->static_falsecount==0){    
    ans=find_answer_of(ss,sans);
    ans->total_support_count--;
    if(ans->dl>=(getmax(ss->static_maxdl,sans->dl)+1)){
      ans->acyclic_support_count--;
      if(ans->acyclic_support_count==0)
	enque(delq,ans);
    }
  }
}

void mark_setsupport_static(setsupportnodeptr ss)
{
  ornodeptr sourceans,targetans;
  Cell * sym;
  int dl;

  ss->static_falsecount++;

  if(ss->static_falsecount==1){
    ALNptr pALN;
    VariantSF subg=ss->dynamic_answer_subg;
    if(IsNonNULL(subg)){
#ifdef DIPTI_ASSERTION
      if(IsNULL(subg_ans_list_ptr(subg)))
	xsb_abort("Answerlist is NULL");
#endif
      pALN=subg_answers(subg);    
      while( IsNonNULL(pALN)) {       
	BTNptr leaf=ALN_Answer(pALN);      
	sourceans=leaf->ornode;
	if(!IsDeletedNode(sourceans->leaf)){
	  targetans=find_answer_of(ss,sourceans);
	  targetans->total_support_count--;
	  dl=sourceans->dl;
	  if(targetans->dl>=(getmax(ss->static_maxdl,dl)+1)){
	    targetans->acyclic_support_count--;
	    if(targetans->acyclic_support_count==0)
	      enque(delq,targetans);
	  }
	}
	pALN=ALN_Next(pALN);
      }
    }
  }    
}

/*================================================================*/
/*                              Adjust                            */
/*================================================================*/

void adjust()
{
  orlistptr ptr,next;
  ornodeptr ornode;
  ornodeptr sourceans;
  andnodeptr support;
  setsupportlistptr ssl;
  setsupportnodeptr ss;
  int running_max;
  ALNptr pALN;
  int no_adjusted=0;
  int count,count1;
  VariantSF headsubg,lastcallsubg;

  redq=initq();

  for(ptr=delta_assumption;IsNonNULL(ptr);ptr=next) {
    next=ptr->next;
    ornode=ptr->item;
    if(ornode->total_support_count>0){
#ifdef DIPTI_ASSERTION    
      count=count1=0;
#endif
      no_adjusted++;
      enque(redq,ornode);
      ornode->acyclic_support_count=ornode->total_support_count;    
      running_max=-1;
      support=ornode->support;
      while(support!=NULL){
	if(support->falsecount==0){
#ifdef DIPTI_ASSERTION     
	  count++;
#endif
	  if(support->dl>running_max)
	    running_max=support->dl;
	}	  
	support=support->next_andnode;
      }
#ifdef DIPTI_ASSERTION    
      count1=count;
#endif		  
      headsubg=get_subgoal(ornode);
      ssl=headsubg->rsslptr;
#ifdef DIPTI_DEBUG
        printf("\n\n");
        printf("<<");debugornode(ornode);printf(">>");
        printf("\n");
#endif
      while(ssl!=NULL){
	ss=ssl->item;
#ifdef DIPTI_DEBUG
	sfPrintGoal(stdout,ss->dynamic_answer_subg,NO);printf("\n\n");
#endif	
	
	if(ss->static_falsecount==0){
	  /* 
	   Step1:  Find the ornode ans 
	   Step2:  Generate the dynamic answer trie mapping for trie path
	           computed at step1
	   Step3:  Find the set of answers in dynamic answer trie for 
	           dynamic answer trie path computed at step2
	  */
	  
	  /* first try 
	     special case approach:
	     answer template for head and lastcall matches  
	  */
	  if(ss->maplen>0){
	    sourceans=find_reverse_mapping1(ss,ornode);
	    if(IsNonNULL(sourceans)){
	     
	      if(!IsDeletedNode(sourceans->leaf)){
#ifdef DIPTI_ASSERTION
		count++;
#endif
		int dlen=getmax(ss->static_maxdl,sourceans->dl)+1;
		if(running_max<dlen){
		  running_max=dlen;
		}
	      }
	    }
	  }
	  else {
	    pALN=subg_answers(ss->dynamic_answer_subg);    
	    while( IsNonNULL(pALN)){       
	      BTNptr leaf=ALN_Answer(pALN);      
	      sourceans=leaf->ornode;
	      
	      if(!IsDeletedNode(sourceans->leaf)){
		int dlen=getmax(ss->static_maxdl,sourceans->dl)+1;
		if(running_max<dlen){
		  running_max=dlen;
		}
	      }
	      pALN=ALN_Next(pALN);
	    }
	  }
	}
	ssl=ssl->next;
      }
#ifdef DIPTI_ASSERTION    
      if(count!=ornode->total_support_count){
	printf("\ncount %d tsc %d  count1 %d adjusted=%d\n",count,ornode->total_support_count,count1,no_adjusted);
	xsb_abort("Adjust error");
      }
#endif	
      
      ornode->dl=running_max;
    }
  }

  printf("No of answers adjusted %d\n",no_adjusted);
}


/*================================================================*/
/*                        Rederivation Phase                      */
/*================================================================*/

void rederivation_phase()
{
  orlistptr ptr,next;
  ornodeptr ornode;
  
  while((ornode=deque(redq))!=NULL)
    rederive_answer(ornode);    
}

void rederive_answer(ornodeptr ptrornode)
{
  andlistptr temp=ptrornode->uses_of;
  setsupportlistptr ssl,sslist;
  
  undelete_branch(ptrornode->leaf);
  no_red++;
  
  while(temp!=NULL){    
    rederive_support(temp->item,ptrornode->dl);
    temp=temp->next;
  }
  sslist=ptrornode->set_uses_of;
  while(IsNonNULL(sslist)&&(IsNonNULL(sslist->item->dynamic_answer_subg))){
    rederive_setsupport_static(sslist->item,ptrornode->dl);
    sslist=sslist->next;
  }
  VariantSF subg=get_subgoal(ptrornode);
  ssl=subg->sslptr;
  while((IsNonNULL(ssl))&&(IsNonNULL(ssl->item))){
    rederive_setsupport_dynamic(ssl->item,ptrornode);
    ssl=ssl->next;
  }
}

void rederive_support(andnodeptr s,int dlen)
{
  s->dl=getmax(s->dl-1,dlen)+1;
  s->falsecount--;
  if(s->falsecount==0)
    recalculate_parameters(s->answer_of,s->dl);    
}

void recalculate_parameters(ornodeptr ans,int dlen)
{
  ans->total_support_count++;
  if(ans->acyclic_support_count==0){
    #ifdef DIPTI_ASSERTION
    if(ans->total_support_count!=1){
      printf("%d",ans->total_support_count);
      xsb_abort("recalculate parameters: assertion failure");
    }
    #endif
    ans->acyclic_support_count=1;
    ans->dl=dlen;
    enque(redq,ans);    
  }
  else{
    if(ans->dl>=dlen)
      ans->acyclic_support_count++;
  }
}

void rederive_setsupport_dynamic(setsupportnodeptr ss,ornodeptr sans)
{
  ornodeptr ans;
  int len;

  if(ss->static_falsecount==0){
    ans=find_answer_of(ss,sans);
    len=getmax(ss->static_maxdl,sans->dl)+1;
    recalculate_parameters(ans,len);
  }  
}

void rederive_setsupport_static(setsupportnodeptr ss,int dl)
{
  ornodeptr sourceans,targetans;

  ss->static_maxdl=getmax(ss->static_maxdl,dl);
  ss->static_falsecount--;
  if(ss->static_falsecount==0){
    VariantSF subg=ss->dynamic_answer_subg;
#ifdef DIPTI_ASSERTION
    if(IsNULL(subg_ans_list_ptr(subg)))
      xsb_abort("Answerlist is NULL");
#endif
    ALNptr pALN;
    pALN=subg_answers(subg);   
    while(IsNonNULL(pALN)){ 
      BTNptr leaf=ALN_Answer(pALN);      
      sourceans=leaf->ornode;
      if(sourceans->acyclic_support_count>0){
	targetans=find_answer_of(ss,sourceans);
	int len=getmax(ss->static_maxdl,sourceans->dl)+1;
	recalculate_parameters(targetans,len);
      }
      pALN=ALN_Next(pALN);
    }
  }
}

/*----------------------End of file support.c---------------------*/
