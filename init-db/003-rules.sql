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