all: build/ch/epfl/biorob/optimization/messages/task/Java.java
	cd build/ch/epfl/biorob/optimization/messages/task && \
	javac -classpath .:/usr/share/java/protobuf-2.0.3.jar Java.java

build/ch/epfl/biorob/optimization/messages/task/Java.java: task.proto
	mkdir -p build
	protoc --proto_path . --java_out build task.proto

clean:
	rm -f *.class
