#include "cinterf.h"

int minus_one(void)
{
  int i = ptoc_int(1);
  ctop_int(2,i-1);
  return 1;
}

int zero(void)
{
  ctop_int(1,0);
  return 1;
}

int plus_one(void)
{
  int i = ptoc_int(1);
  ctop_int(2,i+1);
  return 1;
}

int diag(void)
{
  int n = ptoc_int(1);
  ctop_int(2,n);
  return 1;
}
