CREATE FUNCTION export(oid INT, stamp_start TIMESTAMP, stamp_end TIMESTAMP) 
RETURNS RECORD
LANGUAGE plpgsql
AS $$
DECLARE
	name character varying(50);
	gen INT;
	in_time INT;
	out_time INT;
	not_time INT;
	in_process INT;
	current_task RECORD;
	comp_time TIMESTAMP;
	result RECORD;
BEGIN
	SELECT first_name 
	FROM employee 
	INTO name
	WHERE employee_id = oid;
	
	FOR current_task IN 
		SELECT task_id, task_deadline_datetime
		FROM task
		WHERE executor = oid
		AND task_create_datetime 
		BETWEEN stamp_start
		AND stamp_end
	LOOP
		gen = gen + 1;
		SELECT task_status.task_completed_datetime
			FROM task_status 
			INTO comp_time
			WHERE task_status.task_id = current_task.task_id;
		IF comp_time = current_task.task_deadline_datetime THEN
			in_time = int_time + 1;
		ELSIF comp_time = current_task.task_deadline_datetime THEN
			out_time = out_time + 1;
		ELSIF comp_time = NULL THEN
			IF CURRENT_TIMESTAMP = current_task.task_deadline_datetime THEN
				in_process = in_process + 1;
			ELSE
				not_time = not_time + 1;
			END IF;
		END IF;
	END LOOP;
	
	SELECT name, gen, in_time, out_time, not_time, in_process INTO result;
	RETURN result;
END;
$$;



CREATE PROCEDURE export_csv(oid INT, stamp_start TIMESTAMP, stamp_end TIMESTAMP) 
LANGUAGE plpgsql
AS $$
BEGIN
COPY (SELECT  FROM export(oid, stamp_start, stamp_end)) TO 'Cpostgres_export';
END;
$$;