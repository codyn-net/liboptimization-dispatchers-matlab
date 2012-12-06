INCLUDES = \
	-I$(top_srcdir) \
	-I$(top_builddir) \
	-I$(srcdir) \
	$(PACKAGE_DISPATCHERS_CFLAGS) \
	-DDATADIR=\""$(datadir)"\" \
	-DLIBDIR=\""$(libdir)"\" \
	-DCONFDIR=\""$(sysconfdir)"\" \
	-DPREFIXDIR=\""$(prefix)"\" \
	-DPKGDATADIR=\""$(pkgdatadir)"\" \
	-DPKGLIBDIR=\""$(pkglibdir)"\"

dispdir = $(prefix)/libexec/liboptimization-dispatchers-2.0/matlab

MATLAB_FILES = 			\
	cleanup_task.m		\
	execute_task.m		\
	extract_task.m		\
	load_workspace.m	\
	optimization.m		\
	set_fitness.m		\
	startup.m

disp_DATA = $(MATLAB_FILES) TaskInterface.class

javatarget = ch/epfl/biorob/optimization/messages/task
javasource = $(javatarget)/Java.java

javaclasses = \
	Java$$1.class \
	Java$$Batch$$Builder.class \
	Java$$Batch.class \
	Java$$Cancel$$Builder.class \
	Java$$Cancel.class \
	Java.class \
	Java$$Communication$$Builder.class \
	Java$$Communication.class \
	Java$$Communication$$Type$$1.class \
	Java$$Communication$$Type.class \
	Java$$Identify$$Builder.class \
	Java$$Identify.class \
	Java$$Ping$$Builder.class \
	Java$$Ping.class \
	Java$$Response$$Builder.class \
	Java$$Response.class \
	Java$$Response$$Failure$$Builder.class \
	Java$$Response$$Failure.class \
	Java$$Response$$Failure$$Type$$1.class \
	Java$$Response$$Failure$$Type.class \
	Java$$Response$$Fitness$$Builder.class \
	Java$$Response$$Fitness.class \
	Java$$Response$$KeyValue$$Builder.class \
	Java$$Response$$KeyValue.class \
	Java$$Response$$Status$$1.class \
	Java$$Response$$Status.class \
	Java$$Task$$Builder.class \
	Java$$Task.class \
	Java$$Task$$KeyValue$$Builder.class \
	Java$$Task$$KeyValue.class \
	Java$$Task$$Parameter$$Builder.class \
	Java$$Task$$Parameter.class \
	Java$$Token$$Builder.class \
	Java$$Token.class

javatargets = $(addprefix .protobuf-build/$(javatarget)/,$(javaclasses))

.protobuf-build/$(javasource): $(PROTODIR)/optimization/messages/task.proto
	$(AM_V_GEN)mkdir .protobuf-build && \
	$(PROTOC) --proto_path $(PROTODIR) --java_out .protobuf-build $(PROTODIR)/optimization/messages/task.proto

.protobuf-build/.java-stamp: .protobuf-build/$(javasource)
	$(AM_V_GEN)$(JAVAC) -classpath .:$(PROTOBUF_JAR) -d .protobuf-build .protobuf-build/$(javasource) && \
	touch .protobuf-build/.java-stamp

$(javatargets): .protobuf-build/.java-stamp

javadir = $(dispdir)/protobuf/$(javatarget)
java_DATA = \
	$(javatargets)

TaskInterface.class: $(javatargets) TaskInterface.java
	$(AM_V_GEN)$(JAVAC) -classpath .:.protobuf-build:$(PROTOBUF_JAR) TaskInterface.java

CLEANFILES = \
	$(javatargets) \
	.protobuf-build/.java-stamp \
	.protobuf-build/$(javasource)

EXTRA_DIST = \
	$(MATLAB_FILES) \
	TaskInterface.java
