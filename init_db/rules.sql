--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!

--Роли
CREATE ROLE admin WITH
  LOGIN
  PASSWORD 'SuperParol1337'
  CREATEDB
  CREATEROLE;

CREATE ROLE manager;

CREATE ROLE salaga;

-- Процедуры и т.д.

--Менеджер
--    Создать задания:
CREATE PROCEDURE create_task (
	task_id INTEGER
	,cp_id INT
	,executor INTEGER
	,cont_num BIGINT
	,description TEXT
	,deadline TIMESTAMP
	,priority SMALLINT
	) LANGUAGE SQL
AS
$$

INSERT INTO task (
	task_id
	,c_p_id
	,executor
	,creator
	,task_decription
	,task_create_datetime
	,task_deadline_datetime
	)
VALUES (
	task_id
	,cp_id
	,executor
	,to_regrole(CURRENT_USER)
	,description
	,CURRENT_TIMESTAMP
	,deadline
	);

INSERT INTO task_status (
	task_id
	,task_status_name
	,task_priority
	)
VALUES (
	task_id
	,'N'
	,priority
	);$$;
	
REVOKE ALL ON PROCEDURE create_task FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE create_task TO manager, admin;

--    Изменить:
CREATE POLICY edit_task ON task
FOR
UPDATE TO manager USING (creator = to_regrole(current_user));


GRANT UPDATE (executor)
	ON task
	TO manager;

--    Просматривать:
CREATE POLICY manager_view_tasks ON task
FOR
SELECT TO manager USING (
		creator = to_regrole(CURRENT_USER)
		OR (
			SELECT post_id
			FROM employee
			WHERE employee_id = executor
			) = to_regrole('salaga')
		);

--Все
--    Помечать задание как выполненное:
CREATE PROCEDURE complete_task (task_id INTEGER) LANGUAGE SQL
AS
$$

UPDATE task_status
SET task_status_name = 'C'
	,task_completed_datetime = CURRENT_TIMESTAMP
WHERE task_id = task_id $$;


REVOKE ALL ON PROCEDURE complete_task FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE complete_task TO manager, salaga, admin;

--Салага (рядовой сотрудник)
--	Просматривать

CREATE POLICY salaga_view_tasks ON task
FOR
SELECT TO salaga USING (
		executor = to_regrole(CURRENT_USER));

-- 	Пометить задание как выполненное
-- 	См. соотв. пункт 

--Функции для выгрузки данных
--	Функции поиска среди заказчиков

CREATE FUNCTION find_comp(param varchar) RETURNS TABLE (f1 bigint, f2 varchar(100), f3 boolean, f4 varchar(20), f5 text)
AS $$
BEGIN
	RETURN QUERY 
	SELECT * FROM company
	WHERE company_name LIKE '%' || param || '%'
	OR address LIKE '%' || param || '%';
END;
$$
LANGUAGE plpgsql;

CREATE FUNCTION find_emp(param varchar) RETURNS TABLE (f1 int, f2 bigint,f3 bigint, f4 varchar(100), f5 varchar(50),f6 varchar(50),f7 varchar(50))
AS $$
BEGIN
	RETURN QUERY 
	SELECT * FROM contact_person
	WHERE c_p_first_name LIKE '%' || param || '%' 
	OR c_p_last_name LIKE '%' || param || '%';
END;
$$
LANGUAGE plpgsql;

-- Функция и процедура для выгрузки данных

CREATE FUNCTION export(oid INT, stamp_start TIMESTAMP, stamp_end TIMESTAMP) 
RETURNS TABLE(name employee.first_name%TYPE, gen INT, in_time INT, out_time INT, not_time INT, in_process INT)
LANGUAGE plpgsql
AS $$
DECLARE
	name employee.first_name%TYPE
	gen INT
	in_time INT
	out_time INT
	not_time INT
	in_process INT
	task_id INT
BEGIN
	SELECT first_name 
	FROM employee 
	INTO name
	WHERE oid = oid
	
	FOR task_id IN 
		SELECT task_id, task_deadline_datetime
		FROM task
		WHERE executor = oid
		AND task_create_datetime 
		BETWEEN stamp_start
		AND stamp_end
	LOOP
		gen = gen + 1
		comp_time := SELECT task_completed_datetime FROM task_status
		IF comp_time < task_deadline_datetime THEN
			in_time = int_time + 1
		ELSIF comp_time > task_deadline_datetime THEN
			out_time = out_time + 1
		ELSIF comp_time = NULL THEN
			IF CURRENT_TIMESTAMP < task_deadline_datetime THEN
				in_process = in_process + 1
			ELSE
				not_time = not_time + 1
			END IF
		END IF
	END LOOP;
	
	RETURN (name, gen, in_time, out_time, not_time, in_process)
END;
$$

CREATE PROCEDURE export_csv(oid INT, stamp_start TIMESTAMP, stamp_end TIMESTAMP) 
LANGUAGE SQL
AS
$$
COPY (SELECT * FROM export(oid, stamp_start, stamp_end)) TO '%USR%/postgres_export/' || oid || '.csv'
$$