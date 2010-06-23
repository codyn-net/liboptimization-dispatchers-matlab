function optimization(port, exit_after_one)
	import java.io.*;
	import java.net.*;

	global opticfg

	if nargin < 3
		exit_after_one = 0;
	end

	import ch.epfl.biorob.optimization.messages.task.*;

	server = ServerSocket();
	server.setReuseAddress(true);
	server.bind(InetSocketAddress(port));

	opticfg.server_socket = server;

	while 1
		disp(['[', datestr(now, 'dd-mm HH:MM:SS'), '] Waiting for new task...']);

		try
			connection = server.accept();
		catch exception
			disp(exception);
			disp(exception.message);
			break
		end
	
		try
			task = TaskInterface.Read(connection.getInputStream());

			% Matlab does not support nested classes, so this is a bit lame
			% but at least it works
			comm = TaskInterface.CreateCommunication();
			response = TaskInterface.CreateResponse();

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
				                         'The `world'' does not have a `run'' method');
			else
				wd = pwd();
				origpath = path;

				cd(w);
				rehash;

				try
					evaluate(task, response);
				catch
				end

				cd(wd);
				path(origpath);

				rehash;
			end

			if ~response.isInitialized()
				response = TaskInterface.CreateResponse();

				TaskInterface.SetFailure(response,...
				                         Java.Response.Failure.Type.NoResponse,
				                         'Invalid response from evaluator');
			end

			comm.setResponse(response.build());

			if ~connection.isClosed()
				TaskInterface.Write(connection.getOutputStream(), comm);
				connection.close();
			end

			if ~isempty(TaskInterface.Setting(task, 'optiextractor'))
				exit_after_one = 1;
			end
		catch exception
			disp(exception);
			disp(exception.message);
		end

		if exit_after_one
			break;
		end

		evalin('base', 'clear all');
	end

	server.close();
end
