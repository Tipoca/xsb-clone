extern void ctop_int(int, int);
extern int ptoc_int(int);

void minus_one(void)
{
  int i = ptoc_int(1);
  ctop_int(2,i-1);
}

void zero(void)
{
  ctop_int(1,0);
}

void plus_one(void)
{
  int i = ptoc_int(1);
  ctop_int(2,i+1);
}

void diag(void)
{
  int n = ptoc_int(1);
  ctop_int(2,n);
}
