:- foreign_pred init(+reorder) from 
	initc(reorder:int):void.
:- foreign_pred reorder(+method) from
        reorderc(method:int):void.
:- foreign_pred end from 
	endc:void.
:- foreign_pred ret_prob(+node, -retval) from 
	ret_probc(node:int):float.

:- foreign_pred add_var(+nVal, +probs,-retval) from 
	add_varc(nVal:int,probs:term):int.

:- foreign_pred equality(+varIndex,+ value,-retval) from 
	equalityc(varIndex:int,value:int):int. 

:- foreign_pred one(-retval) from 
	onec:int. 
:- foreign_pred zero(-retval) from 
	zeroc:int. 
:- foreign_pred bdd_not(+node,-retval) from 
	bdd_notc(node:int):int. 
:- foreign_pred and(+nodea,+nodeb,-retval) from 
	andc(nodea:int,nodeb:int):int. 
:- foreign_pred or(+nodea,+nodeb,-retval) from 
	orc(nodea:int,nodeb:int):int. 

:- foreign_pred create_dot(+node,+filename) from 
	create_dotc(node:int,filename:term):void. 

:- foreign_pred rec_deref(+node) from 
	rec_derefc(node:int):void. 

:- ldoption('-lcudd -lepd -lmtr -lutil -lst -lglib-2.0 -lm ').    
