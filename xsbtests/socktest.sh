#! /bin/sh

## File:      socktest.sh  - script for testing sockets
## Author(s): Michael Kifer
## Contact:   xsb-contact@cs.sunysb.edu
## 
## Copyright (C) The Research Foundation of SUNY, 1999
## 
## XSB is free software; you can redistribute it and/or modify it under the
## terms of the GNU Library General Public License as published by the Free
## Software Foundation; either version 2 of the License, or (at your option)
## any later version.
## 
## XSB is distributed in the hope that it will be useful, but WITHOUT ANY
## WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
## FOR A PARTICULAR PURPOSE.  See the GNU Library General Public License for
## more details.
## 
## You should have received a copy of the GNU Library General Public License
## along with XSB; if not, write to the Free Software Foundation,
## Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
##
## $Id: socktest.sh,v 1.1 1999-11-15 00:12:57 kifer Exp $
## 
##

# THIS SCRIPT EXPECTS TO BE RUN FROM THE TESTSUITE DIRECTORY

# $1 must be the path to the XSB installation directory


if test -z "$1" -o $# -gt 1; then
    echo "Usage: socktest.sh <path>"
    echo "where: "
    echo "       path      -- full path name of the XSB installation directory"
    echo ""
    exit
fi

testsuite.sh -only socket_tests  $1
