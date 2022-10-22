
-- ДОСТУП admin 

GRANT DELETE, INSERT, UPDATE, SELECT ON ALL TABLES IN SCHEMA public TO admin;


CREATE PROCEDURE add_employee(
		post_name character varying,
		first_name character varying(50),
		middle_name character varying(50),
		last_name character varying(50),
		email character varying(50),
		phone_number bigint,
		user_nickname character varying(12),
		user_password character varying(12)
		)
	AS $$
	BEGIN
		-- Создаём новую роль для пользователя
		EXECUTE FORMAT('CREATE ROLE %I PASSWORD %L', user_nickname, user_password);
		--	Наследуем права от соответствующей роли
		EXECUTE FORMAT('GRANT %I TO %I', post_name, user_nickname);
		--	Заполняем таблицу 
		INSERT INTO employee(
			employee_id,
			post_id,
			e_first_name,
			e_middle_name,
			e_last_name,
			e_email,
			e_phone_number,
			e_nickname,
			e_password)
			
		VALUES(
			to_regrole(user_nickname),
			to_regrole(post_name),
			first_name,
			middle_name,
			last_name,
			email,
			phone_number,
			user_nickname,
			user_password);
			
	End;
	$$
	LANGUAGE plpgsql;

	

-- процедура удаления работника
-- по идее можно удалить если нету активных записей
-- иначе придется ебаться с тем чтобы переназначить таски другим работникам

CREATE PROCEDURE delete_employee(e_id INTEGER)
AS
$$
BEGIN
	--Удаляем запись о сотруднике из таблицы
	DELETE FROM employee 
	WHERE
		employee_id = e_id;
	
	-- Убираем роль
	EXECUTE FORMAT('REVOKE salaga, manager FROM %I', pg_get_userbyid(e_id));
	
	-- Удаляем роль
	EXECUTE FORMAT('DROP ROLE %I', pg_get_userbyid(e_id));
END;
$$
LANGUAGE plpgsql;

-- Выдаем права админу
-- ПРОВЕРИТЬ НАПИСАНИЕ!!

REVOKE ALL ON PROCEDURE add_employee, delete_employee FROM PUBLIC;

GRANT EXECUTE ON PROCEDURE add_employee, delete_employee TO admin;

