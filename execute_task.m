function [ws, w, tpath] = execute_task(task, response)
    import ch.epfl.biorob.optimization.messages.task.*;

    w = char(TaskInterface.Setting(task, 'world'));

    ws = struct();
    tpath = path;

    if isempty(w)
        TaskInterface.SetFailure(response,...
                                 TaskInterface.FailureWrongRequest,...
                                 'The setting `world'' is not provided');
    elseif ~exist(w)
        TaskInterface.SetFailure(response,...
                                 TaskInterface.FailureWrongRequest,...
                                 sprintf('The `world'' (%s) could not be found', w));
    elseif ~exist(fullfile(w, 'evaluate.m'))
        TaskInterface.SetFailure(response,...
                                 TaskInterface.FailureWrongRequest,...
                                 'The `world'' does not have an `evaluate'' method');
    else
        wd = pwd();
        origpath = path;

        funcs.load_workspace = @load_workspace;
        funcs.extract_task = @extract_task;
        funcs.set_fitness = @set_fitness;

        c = onCleanup(@()cleanitup(wd, origpath));

        cd(w);
        rehash;

        try
            % Try to get the workspace
            workspace = char(TaskInterface.Setting(task, 'workspace'));

            if isempty(workspace)
                workspace = 'workspace.mat';
            end

            if workspace(1) ~= '/'
                workspace = fullfile(w, workspace);
            end

            t = funcs.extract_task(task);
            ws = funcs.load_workspace(workspace);

            if nargout('evaluate') == 2
                if nargin('evaluate') == 2
                    [fit, data] = evaluate(t, ws);
                else
                    [fit, data] = evaluate(t);
                end
            else
                if nargin('evaluate') == 2
                    fit = evaluate(t, ws);
                else
                    fit = evaluate(t);
                end

                data = struct();
            end

            tpath = path;
            funcs.set_fitness(fit, data, response);
        catch exception
            disp(getReport(exception));
        end
    end
end

function cleanitup(wd, p)
    cd(wd);
    path(p);
    rehash;
end

% vi:ts=4:et
