#include<stdlib.h>

#include "cinterf.h"

int prand(void)
{
  ctop_int(1,rand());
  return(1);
}

