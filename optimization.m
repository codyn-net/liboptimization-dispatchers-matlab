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

    c = onCleanup(@()server.close());

    opticfg.server_socket = server;
    hasrun = 0;

    disp(['[', datestr(now, 'dd-mm HH:MM:SS'), '] Waiting for new task...']);

    while 1
        try
            server.setSoTimeout(2000);
            connection = server.accept();
        catch exception
            if ~isempty(regexp(exception.message, 'java.net.SocketTimeoutException', 'once'))
                continue;
            end

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

            ws = struct();
            wd = pwd;
            tpath = path;

            try
                % Execute the task from the task description
                [ws, wd, tpath] = execute_task(task, response);
            catch exception
                % If an exception occurs while executing the task, we are
                % going to set a failure with the report as a failure message
                response = TaskInterface.CreateResponse();

                TaskInterface.SetFailure(response,...
                                         Java.Response.Failure.Type.Dispatcher,...
                                         getReport(exception));
            end

            % If the response was not initialized by the execution of the task
            % then the execution did not set a fitness
            if ~response.isInitialized()
                response = TaskInterface.CreateResponse();

                TaskInterface.SetFailure(response,...
                                         Java.Response.Failure.Type.NoResponse,...
                                         'Invalid response from evaluator');
            end

            % Send back the response
            comm.setResponse(response.build());

            if ~connection.isClosed()
                TaskInterface.Write(connection.getOutputStream(), comm);
                connection.close();
            end

            % Exit after one execution if we are being run from the optiextractor
            if ~isempty(TaskInterface.Setting(task, 'optiextractor'))
                evalin('base', ['global ', 'lastws']);
                assignin('base', 'lastws', ws);

                path(tpath);
                cd(wd);

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
        disp(['[', datestr(now, 'dd-mm HH:MM:SS'), '] Waiting for new task...']);
    end
end

% vi:ts=4:et
