AC_INIT(liboptimization-dispatchers-matlab, 2.2)

AM_INIT_AUTOMAKE([gnu no-dist-gzip tar-ustar dist-xz -Wno-portability])

AC_CONFIG_MACRO_DIR([m4])

AC_ISC_POSIX
AC_STDC_HEADERS
AC_HEADER_STDC

AC_PROG_INSTALL
AC_PROG_MAKE_SET
PKG_PROG_PKG_CONFIG

AM_MAINTAINER_MODE

m4_ifdef([AM_SILENT_RULES],[AM_SILENT_RULES([yes])])

AC_PATH_PROG([PROTOC], [protoc], [AC_MSG_ERROR([failed to find protoc])])
AC_SUBST(PROTOC)

AC_PATH_PROG([JAVAC], [javac], [AC_MSG_ERROR([failed to find javac])])
AC_SUBST(JAVAC)

dnl Checking for protobuf java package
AC_MSG_CHECKING([for protobuf java])

PROTOBUFJARS="protobuf.jar protobuf-java.jar"
JAVAJARDIRS="$prefix/java /usr/local/share/java /usr/share/java"

for f in $PROTOBUFJARS; do
	for d in $JAVAJARDIRS; do
		if test -f "$d/$f"; then
			PROTOBUF_JAR="$d/$f"
			break;
		fi
	done

	if test ! -z "$PROTOBUF_JAR"; then
		break
	fi
done

if test -z "$PROTOBUF_JAR"; then
	AC_MSG_ERROR([failed to find protobuf java])
else
	AC_MSG_RESULT([found in $PROTOBUF_JAR])
fi

AC_SUBST(PROTOBUF_JAR)

PKG_CHECK_EXISTS([liboptimization-2.0], [], [AC_MSG_ERROR([failed to find liboptimization-2.0])])

PROTODIR=`$PKG_CONFIG --variable=protodir liboptimization-2.0`
AC_SUBST(PROTODIR)

AC_OUTPUT(
Makefile
startup.m
)
