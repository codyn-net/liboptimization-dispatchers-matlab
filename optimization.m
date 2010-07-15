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

			execute_task(task, response);

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
			else
				cleanup_path = fullfile(w, 'cleanup.m');

				if exist(cleanup_path)
					run(cleanup_path);
				end
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
