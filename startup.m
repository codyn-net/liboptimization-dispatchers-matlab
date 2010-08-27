javaaddpath('.');
javaaddpath('protobuf/build');
javaaddpath('/usr/share/java/protobuf-2.2.0.jar');

if strcmp(getenv('OPTIMIZATION_EXTERNAL'), '') == 0
	optimization(str2num(getenv('OPTIMIZATION_EXTERNAL_PERSISTENT')));
end
