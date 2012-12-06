function set_fitness(fit, data, response)
    import ch.epfl.biorob.optimization.messages.task.*;

    if isstruct(data)
        names = fieldnames(data);

        for n = 1:length(names)
            name = names{n};
            TaskInterface.AddData(response, name, char(data.(name)));
        end
    end

    if isstruct(fit)
        names = fieldnames(fit);

        for n = 1:length(names)
            name = names{n};

            val = fit.(name);

            if ~isempty(val)
                TaskInterface.AddFitness(response, name, fit.(name));
            end
        end
    else if ismatrix(fit)
        for v = 1:length(fit)
            name = ['v' num2str(v)];
            TaskInterface.AddFitness(response, char(name), fit(v));
        end
    end
end

% vi:ts=4:et
