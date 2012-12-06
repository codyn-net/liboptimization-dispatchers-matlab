AC_INIT(liboptimization-dispatchers-matlab, 2.1)

AM_INIT_AUTOMAKE(AC_PACKAGE_NAME, AC_PACKAGE_VERSION)

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
AC_MSG_CHECKING([protobuf java])

PROTOBUFJARS = protobuf.jar protobuf-java.jar
JAVAJARDIR = $prefix/java /usr/local/share/java /usr/share/java

for f in $PROTOBUFJARS; do
	if [ -f $JAVAJARDIR/$f ]; then
		PROTOBUF_JAR = $JAVAJARDIR/$f
		break;
	fi
done

if [ -z $PROTOBUF_JAR; ] then
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
)
