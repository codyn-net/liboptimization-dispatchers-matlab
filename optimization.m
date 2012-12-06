function optimization(port, exit_after)
	import java.io.*;
	import java.net.*;

	global opticfg
	evalin('base', 'global opticfg');

	if nargin < 2
		exit_after = 0;
	end

	import ch.epfl.biorob.optimization.messages.task.*;

	server = ServerSocket();
	server.setReuseAddress(true);
	server.bind(InetSocketAddress(port));

	opticfg.server_socket = server;
	hasrun = 0;

	while 1
		disp(['[', datestr(now, 'dd-mm HH:MM:SS'), '] Waiting for new task...']);

		try
			connection = server.accept();
		catch exception
			disp(getReport(exception));
			break
		end

		try
			task = TaskInterface.Read(connection.getInputStream());

			if ~isempty(TaskInterface.Setting(task, '__stop__'))
				exit_after = 1;
			end

			% Matlab does not support nested classes, so this is a bit lame
			% but at least it works
			comm = TaskInterface.CreateCommunication();
			response = TaskInterface.CreateResponse();

			try
				execute_task(task, response);
			catch exception
				response = TaskInterface.CreateResponse();

				TaskInterface.SetFailure(response,...
				                         Java.Response.Failure.Type.Dispatcher,...
				                         getReport(exception));
			end

			if ~response.isInitialized()
				response = TaskInterface.CreateResponse();

				TaskInterface.SetFailure(response,...
				                         Java.Response.Failure.Type.NoResponse,...
				                         'Invalid response from evaluator');
			end

			comm.setResponse(response.build());

			if ~connection.isClosed()
				TaskInterface.Write(connection.getOutputStream(), comm);
				connection.close();
			end

			if ~isempty(TaskInterface.Setting(task, 'optiextractor'))
				exit_after = 1;
			else
				cleanup_task(task);
			end
		catch exception
			disp(getReport(exception));
		end

		hasrun = hasrun + 1;

		if exit_after > 0 && hasrun >= exit_after
			break;
		end

		evalin('base', 'clear all');
	end

	server.close();
end
