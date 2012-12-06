% Main entry point for the matlab dispatcher

javaaddpath('.');
javaaddpath('protobuf/build');

jars = {'/usr/share/java/protobuf.jar', '/usr/share/java/protobuf-java.jar'};

for i = 1:length(jars)
    if exist(jars{i}, 'file')
        javaaddpath(jars{i});
        break
    end
end

if strcmp(getenv('OPTIMIZATION_EXTERNAL'), '') == 0
    optimization(str2num(getenv('OPTIMIZATION_EXTERNAL_PERSISTENT')));
end

% vi:ts=4:et
