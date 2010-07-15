PREFIX=/usr
DEST=$(PREFIX)/libexec/liboptimization-dispatchers-2.0/matlab

SCRIPTS=execute_task.m optimization.m startup.m TaskInterface.class protobuf

all: taskinterface

taskinterface: protobuf TaskInterface.java
	javac -classpath .:protobuf/build:/usr/share/java/protobuf-2.0.3.jar TaskInterface.java

protobuf:
	$(MAKE) -sC protobuf

clean:
	rm -f TaskInterface.class

install:
	mkdir -p $(DEST)
	cp -r $(SCRIPTS) $(DEST)/

.PHONY: protobuf
