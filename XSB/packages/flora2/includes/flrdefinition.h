/************************************************************************
  file: closureinc/flrdefinition_inc.flh

  Author(s): Guizhen Yang

  This file is automatically included by the FLORA compiler.
************************************************************************/

FLORA_WORKSPACE(FLORA_VAR_WORKSPACE,flThisModule)(FLORA_VAR_WORKSPACE).

:- import storage_delete_all/1 from storage.

?- storage_delete_all(FLORA_WSSTORAGE(FLORA_VAR_WORKSPACE)).

/***********************************************************************/

