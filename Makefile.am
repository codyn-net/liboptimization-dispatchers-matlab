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

.protobuf-build/$(javasource): $(PROTODIR)/optimization/messages/task.proto
	$(AM_V_GEN)mkdir -p .protobuf-build && \
	$(PROTOC) --proto_path $(PROTODIR) --java_out .protobuf-build $(PROTODIR)/optimization/messages/task.proto

.protobuf-build/.java-stamp: .protobuf-build/$(javasource)
	$(AM_V_GEN)$(JAVAC) -classpath .:$(PROTOBUF_JAR) -d $(builddir)/.protobuf-build .protobuf-build/$(javasource) && \
	touch .protobuf-build/.java-stamp

javadir = $(dispdir)/protobuf/$(javatarget)

TaskInterface.class: .protobuf-build/.java-stamp TaskInterface.java
	$(AM_V_GEN)$(JAVAC) -classpath .:.protobuf-build:$(PROTOBUF_JAR) -d $(builddir) $(srcdir)/TaskInterface.java

install-data-local: .protobuf-build/.java-stamp
	$(mkinstalldirs) '$(DESTDIR)$(javadir)' && \
	$(INSTALL_DATA) $(foreach i,$(wildcard .protobuf-build/$(javatarget)/*.class),'$(i)') '$(DESTDIR)$(javadir)'

uninstall-local:
	rm -rf $(DESTDIR)$(dispdir)/protobuf

clean-local:
	rm -rf .protobuf-build

CLEANFILES = \
	TaskInterface.class

EXTRA_DIST = \
	$(MATLAB_FILES) \
	TaskInterface.java
