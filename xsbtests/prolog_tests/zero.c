#include "xsb_config.h"
#include "cinterf.h"

DllExport int call_conv minus_one(void)
{
  int i = ptoc_int(1);
  ctop_int(2,i-1);
  return 1;
}

DllExport int call_conv zero(void)
{
  ctop_int(1,0);
  return 1;
}

DllExport int call_conv plus_one(void)
{
  int i = ptoc_int(1);
  ctop_int(2,i+1);
  return 1;
}

DllExport int call_conv diag(void)
{
  int n = ptoc_int(1);
  ctop_int(2,n);
  return 1;
}
