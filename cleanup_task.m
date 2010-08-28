function cleanup_task(task)
    import ch.epfl.biorob.optimization.messages.task.*;

	w = char(TaskInterface.Setting(task, 'world'));

    if ~isempty(w)
        cleanup_path = fullfile(w, 'cleanup.m');

        if exist(cleanup_path)
            run(cleanup_path);
        end
    end