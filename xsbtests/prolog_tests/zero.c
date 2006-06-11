#include "xsb_config.h"
#include "cinterf.h"
#include "context.h"

DllExport int call_conv minus_one(CTXT)
{
  int i = extern_ptoc_int(1);
  extern_ctop_int(2,i-1);
  return 1;
}

DllExport int call_conv zero(CTXT)
{
  extern_ctop_int(1,0);
  return 1;
}

DllExport int call_conv plus_one(CTXT)
{
  int i = extern_ptoc_int(1);
  extern_ctop_int(2,i+1);
  return 1;
}

DllExport int call_conv diag(CTXT)
{
  int n = extern_ptoc_int(1);
  extern_ctop_int(2,n);
  return 1;
}
