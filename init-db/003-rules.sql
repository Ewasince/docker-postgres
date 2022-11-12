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
CREATE PROCEDURE create_task(
	IN task_id integer,
	IN contact_person_id integer,
	IN executor integer,
	IN description text,
	IN deadline timestamp without time zone,
	IN priority smallint,
	IN good_id integer)
LANGUAGE 'sql'
AS $$

INSERT INTO task (
	task_id,
	c_p_id,
	executor,
	creator,
	task_decription,
	task_create_datetime,
	task_deadline_datetime
)
VALUES (
	task_id,
	contact_person_id,
	executor,
	to_regrole(CURRENT_USER),
	description,
	CURRENT_TIMESTAMP,
	deadline);

INSERT INTO task_status (
	task_id,
	task_status_name,
	task_priority)
VALUES (
	task_id,
	'NEW',
	priority);

INSERT INTO goods_task (
	task_id,
	goods_num)
VALUES (
	task_id,
	good_id);
$$;
	
REVOKE ALL ON PROCEDURE create_task FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE create_task TO manager, admin;

GRANT SELECT, INSERT ON task_status TO manager; 
GRANT SELECT, INSERT ON goods_task TO manager;

GRANT UPDATE (task_deadline_datetime) ON task TO manager; 

--    Изменить:
CREATE POLICY edit_task ON task
FOR
UPDATE TO manager USING (creator = to_regrole(current_user));


GRANT SELECT, UPDATE (executor)
	ON task
	TO manager;


GRANT SELECT, INSERT
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
CREATE PROCEDURE complete_task (cur_task_id INTEGER)
LANGUAGE 'sql'
AS
$$
	UPDATE task_status
	SET task_status_name = 'C'
		,task_completed_datetime = CURRENT_TIMESTAMP
	WHERE task_status.task_id = cur_task_id ;
$$;


REVOKE ALL ON PROCEDURE complete_task FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE complete_task TO manager, salaga, admin;
-- GRANT SELECT ON task_status TO manager, salaga
GRANT SELECT, UPDATE (task_status_name, task_completed_datetime) ON task_status TO manager, salaga;

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