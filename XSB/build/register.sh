#! /bin/sh


cat <<EOF
*******************************************************************************

The installation process is now complete. The log is in: Installation_summary

We shall greatly appreciate, if you would agree to send us this log.
Installation logs help the XSB group to keep track of the usage of the
system on different architectures and to isolate problems more easily.

The log will be sent automatically to  \`xsb-installation@lists.sourceforge.net'
Would you like to send us the installation log? (y/n): y
EOF

read sendlog

if test "$sendlog" != "n" -a "$sendlog" != "no" -a "$sendlog" != "N" ; then
    (cat sendlog.msg Installation_summary \
	| mail xsb-installation@lists.sourceforge.net) \
    && echo "" ; echo "Thank you!"; echo ""
fi

