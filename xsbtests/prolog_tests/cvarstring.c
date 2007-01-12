/*   Simple example file showing how to call XSB from C without varstrings  
 *   To make this file, see the instructions in ./README */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* cinterf.h is necessary for the XSB API, as well as the path manipulation routines*/
#include "cinterf.h"

/* context.h is necessary for the type of a thread context. */
#include "context.h"

int main(int argc, char *argv[])
{ 

#ifdef MULTI_THREAD
   static th_context *th ;
   th = malloc( sizeof( th_context ) ) ;  /* don't use mem_alloc */
#endif

  int rc;
  XSB_StrDefine(return_string);

  int myargc = 1;
  char *myargv[1];

  myargv[0] = argv[1];

  if (xsb_init(CTXTc myargc,myargv)) {
    fprintf(stderr,"%s initializing XSB: %s\n",xsb_get_error_type(),xsb_get_error_message());
    exit(XSB_ERROR);
  }

  /* Create command to consult a file: edb.P, and send it. */
  if (xsb_command_string(CTXTc "consult('edb.P').") == XSB_ERROR)
    fprintf(stderr,"++Error consulting edb.P: %s/%s\n",xsb_get_error_type(),xsb_get_error_message());

  rc = xsb_query_string_string(CTXTc "p(X,Y,Z).",&return_string,"|");
  while (rc == XSB_SUCCESS) {
    printf("cvsreturn %s\n",(return_string.string));
    rc = xsb_next_string(CTXTc &return_string,"|");
  }

 if (rc == XSB_ERROR) 
   fprintf(stderr,"++Query Error: %s/%s\n",xsb_get_error_type(),xsb_get_error_message());

  xsb_close(CTXT);      /* Close connection */
  return(0);
}
