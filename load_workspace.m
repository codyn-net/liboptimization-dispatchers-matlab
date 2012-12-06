function ws = load_workspace(workspace)
    ws = struct();

    if ~exist(workspace)
        return
    end

    disp('Loading the simulation workspace...');
    ws = load(workspace);

    names = fieldnames(ws);

    [names, isglobal] = remove_name(names, 'global');
    [names, isexpand] = remove_name(names, 'expand');

    if isexpand && length(names) == 1
        ws = ws.(names{1});
    end

    if isglobal
        for name = 1:length(names)
            n = names{name};

            evalin('base', ['global ', char(n)]);
            assignin('base', n, ws.(n));
        end
    end
end

function [ret, found] = remove_name(names, name)
    ret = {};
    found = 0;

    for n = 1:length(names)
        if ~strcmp(names{n}, name)
            ret{end + 1} = names{n};
        else
            found = 1;
        end
    end
end

% vi:ts=4:et
