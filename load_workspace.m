function load_workspace(workspace)
	if ~exist(workspace)
		return
	end

	disp('Loading the simulation workspace...');
	data = load(workspace);

	names = fieldnames(data);

	for name = 1:length(names)
		n = names{name};

		evalin('base', ['global ', char(n)]);
		assignin('base', n, data.(n));
	end
