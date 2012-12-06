function t = extract_task(task)
    % Extract a more convenient description in matlab structures from an
    % optimization task object

    import ch.epfl.biorob.optimization.messages.task.*;

    t = struct('settings', struct(),...
               'parameters', struct(),...
               'data', struct(),...
               'id', task.getId(),...
               'uniqueid', task.getUniqueid(),...
               'job', char(task.getJob()),...
               'optimizer', char(task.getOptimizer()));

    settings = TaskInterface.Settings(task);

    for s = 1:length(settings)
        setting = settings(s);

        name = normname(char(setting.getKey()));
        t.settings.(name) = char(setting.getValue());
    end

    parameters = TaskInterface.Parameters(task);

    for p = 1:length(parameters)
        parameter = parameters(p);
        name = normname(char(parameter.getName()));

        t.parameters.(name) = struct('value', parameter.getValue(),...
                                     'bounds', [parameter.getMin(), parameter.getMax()]);
    end

    data = TaskInterface.Data(task);

    for d = 1:length(data)
        d = data(d);

        name = normname(char(d.getKey()));

        t.data.(name) = char(d.getValue());
    end
end

function out = normname(s)
    out = strrep(s, '-', '_');
    out = strrep(out, ':', '_');
end

% vi:ts=4:et
