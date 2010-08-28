function execute_task(task, response)
	import ch.epfl.biorob.optimization.messages.task.*;

	w = char(TaskInterface.Setting(task, 'world'));

	if isempty(w)
		TaskInterface.SetFailure(response,...
		                         Java.Response.Failure.Type.WrongRequest,...
		                         'The setting `world'' is not provided');
	elseif ~exist(w)
		TaskInterface.SetFailure(response,...
		                         Java.Response.Failure.Type.WrongRequest,...
		                         'The `world'' could not be found');
	elseif ~exist(fullfile(w, 'evaluate.m'))
		TaskInterface.SetFailure(response,...
		                         Java.Response.Failure.Type.WrongRequest,...
		                         'The `world'' does not have an `evaluate'' method');
	else
		wd = pwd();
		origpath = path;

		load_ws = @load_workspace;

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

			load_ws(workspace);
			evaluate(task, response);
		catch exception
			disp(getReport(exception));
		end

		cd(wd);
		path(origpath);

		rehash;
	end
