function execute_task(task, response)
	w = TaskInterface.Setting('world');

	if isempty(w)
		TaskInterface.SetFailure(response,...
		                         Java.Response.Failure.Type.WrongRequest,...
		                         'The setting `world'' is not provided');
	else if ~exist(w)
		TaskInterface.SetFailure(response,...
		                         Java.Response.Failure.Type.WrongRequest,...
		                         'The `world'' could not be found');
	else if ~exist(fullfile(w, 'evaluate'))
		TaskInterface.SetFailure(response,...
		                         Java.Response.Failure.Type.WrongRequest,
		                         'The `world'' does not have an `evaluate'' method');
	else
		wd = pwd();
		origpath = path;

		cd(w);
		rehash;

		try
			% Try to get the workspace
			workspace = TaskInterface.Setting(task, 'workspace')

			if isempty(workspace)
				workspace = 'workspace.mat';
			end

			if workspace(1) ~= '/'
				workspace = fullfile(w, workspace);
			end


			load_workspace(workspace);
			evaluate(task, response);
		catch
		end

		cd(wd);
		path(origpath);

		rehash;
	end
