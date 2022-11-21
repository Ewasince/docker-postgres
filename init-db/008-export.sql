CREATE TYPE my_type AS (name character varying(50), gen INT, in_time INT, out_time INT, not_time INT, in_process INT);

CREATE FUNCTION export(INT, TIMESTAMP, TIMESTAMP) 
RETURNS my_type 
LANGUAGE plpgsql
AS $$
DECLARE
	name character varying(50);
	gen INT := 0;
	in_time INT := 0;
	out_time INT := 0;
	not_time INT := 0;
	in_process INT := 0;
	current_task RECORD;
	comp_time TIMESTAMP;
	my_result my_type;
	cur_id ALIAS FOR $1;
	stamp_start ALIAS FOR $2;
	stamp_end ALIAS FOR $3;
BEGIN
	SELECT e_first_name 
	FROM employee 
	INTO name
	WHERE cur_id = employee_id;
	
	FOR current_task IN 
		SELECT task_id, task_deadline_datetime
		FROM task
		WHERE task.executor = cur_id
		AND task_create_datetime 
		BETWEEN stamp_start
		AND stamp_end
	LOOP
		gen = gen + 1;
		SELECT task_status.task_completed_datetime
			FROM task_status 
			INTO comp_time
			WHERE task_status.task_id = current_task.task_id;
		IF comp_time <= current_task.task_deadline_datetime THEN
			in_time = in_time + 1;
		ELSIF comp_time > current_task.task_deadline_datetime THEN
			out_time = out_time + 1;
		ELSIF comp_time IS NULL THEN
			IF CURRENT_TIMESTAMP <= current_task.task_deadline_datetime THEN
				in_process = in_process + 1;
			ELSE
				not_time = not_time + 1;
			END IF;
		END IF;
	END LOOP;
	
	SELECT name, gen, in_time, out_time, not_time, in_process INTO my_result.name, my_result.gen, my_result.in_time, my_result.out_time, my_result.not_time, my_result.in_process;
	RETURN my_result;
END;
$$;



CREATE PROCEDURE export_csv(INT, TIMESTAMP, TIMESTAMP) 
LANGUAGE plpgsql
AS $$
DECLARE
	cur_id ALIAS FOR $1;
	stamp_start ALIAS FOR $2;
	stamp_end ALIAS FOR $3;
	statement TEXT;
BEGIN	
	statement := FORMAT('COPY (SELECT * FROM export(%s, %L, %L))
						TO ''/var/lib/postgresql/export/postgres_export.csv'' WITH (FORMAT CSV, HEADER);',
						cur_id, stamp_start, stamp_end);
	EXECUTE statement;
END;
$$;

GRANT EXECUTE ON PROCEDURE export_csv TO admin;
GRANT EXECUTE ON FUNCTION export TO admin;



CREATE PROCEDURE export_json(TIMESTAMP, TIMESTAMP) 
LANGUAGE plpgsql
AS $$
DECLARE	
	stamp_start ALIAS FOR $1;
	stamp_end ALIAS FOR $2;
	statement TEXT;
BEGIN
	statement := FORMAT('COPY (SELECT row_to_json(t) FROM (SELECT * FROM task) as t)
						TO ''/var/lib/postgresql/export/postgres_export_tasks.json'';');
	EXECUTE statement;
END;
$$;

GRANT EXECUTE ON PROCEDURE export_json TO admin;