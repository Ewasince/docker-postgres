

/* Create Tables */

CREATE TABLE Company
(
	-- Регестрационный номер компании.
	company_reg_num bigint NOT NULL,
	-- Наименование компании.
	company_name varchar(100) NOT NULL,
	-- Статус компаниии: true - компнаия является клиентом и с ней уже заключен(ы) контракт(ы), false -компания является потециальный клиентом.
	work_status boolean NOT NULL,
	-- Почтовый индекс компании.
	company_post_index varchar(20) NOT NULL,
	-- Адресс компании.
	company_address text NOT NULL,
	PRIMARY KEY (company_reg_num)
) WITHOUT OIDS;


-- Контакное лицо. Представитель организации, т.е. клиента.
CREATE TABLE Contact_Person
(
	-- Идентификатор контактного лица
	c_p_id int NOT NULL,
	-- Регестрационный номер компании.
	company_reg_num bigint NOT NULL,
	-- Телефонный номер
	c_p_phone_number bigint NOT NULL,
	-- Адресс электронной почты.
	c_p_email varchar(100) NOT NULL,
	-- Имя контактного лица.
	c_p_first_name varchar(50) NOT NULL,
	-- Отчество/второе имя контактного лица.
	c_p_middle_name varchar(50),
	-- Фамилия контактного лица
	c_p_last_name varchar(50) NOT NULL,
	PRIMARY KEY (c_p_id)
) WITHOUT OIDS;


CREATE TABLE Contract
(
	-- Номер контракта
	contract_num bigint NOT NULL,
	-- Описание контракта
	contract_description  xml NOT NULL,
	PRIMARY KEY (contract_num)
) WITHOUT OIDS;


CREATE TABLE Employee
(
	employee_id int NOT NULL,
	-- Код должности сотрудника
	post_id int NOT NULL,
	-- Имя сотрудника
	e_first_name varchar(50) NOT NULL,
	-- Отчество сотрудника
	e_middle_name varchar(50),
	-- Фамилия сотрудника
	e_last_name varchar(50) NOT NULL,
	-- Адрес электронной почты
	e_email varchar(50) NOT NULL,
	-- Телефонный номер сотрудника
	e_phone_number varchar(100) NOT NULL,
	PRIMARY KEY (employee_id)
) WITHOUT OIDS;


CREATE TABLE Goods
(
	-- Серийный номер товара
	goods_num int NOT NULL,
	-- Наименование товара
	-- 
	goods_name varchar(100) NOT NULL,
	-- Описание товара.
	goods_decription xml NOT NULL,
	-- Номер контракта
	contract_num bigint NOT NULL,
	PRIMARY KEY (goods_num)
) WITHOUT OIDS;


CREATE TABLE Goods_Task
(
	-- Номер задания
	task_id int NOT NULL,
	-- Серийный номер товара
	goods_num int NOT NULL,
	-- Примечание
	remark varchar
) WITHOUT OIDS;


CREATE TABLE Post
(
	-- Код должности сотрудника
	post_id int NOT NULL,
	-- Наименование должности сотрудника.
	post_name varchar NOT NULL,
	PRIMARY KEY (post_id)
) WITHOUT OIDS;


CREATE TABLE Task
(
	-- Номер задания
	task_id int NOT NULL,
	-- Идентификатор контактного лица
	c_p_id int NOT NULL,
	-- Исполнитель
	executor int NOT NULL,
	-- Создатель
	creator int NOT NULL,
	-- Описание задания.
	task_decription text NOT NULL,
	-- Дата создания задания
	task_create_datetime timestamp NOT NULL,
	-- Срок исполнения задания
	task_deadline_datetime timestamp,
	PRIMARY KEY (task_id)
) WITHOUT OIDS;


CREATE TABLE Task_Status
(
	-- Номер задания
	task_id int NOT NULL,
	-- Наименование статуса задания.
	task_status_name varchar(50) NOT NULL,
	-- Время выполнения задания. Заполняется после завершения заказа.
	task_completed_datetime timestamp,
	task_priority smallint NOT NULL,
	PRIMARY KEY (task_id)
) WITHOUT OIDS;



/* Create Foreign Keys */

ALTER TABLE Contact_Person
	ADD FOREIGN KEY (company_reg_num)
	REFERENCES Company (company_reg_num)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE Task
	ADD FOREIGN KEY (c_p_id)
	REFERENCES Contact_Person (c_p_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE Goods
	ADD FOREIGN KEY (contract_num)
	REFERENCES Contract (contract_num)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE Task
	ADD FOREIGN KEY (executor)
	REFERENCES Employee (employee_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE Task
	ADD FOREIGN KEY (creator)
	REFERENCES Employee (employee_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE Goods_Task
	ADD FOREIGN KEY (goods_num)
	REFERENCES Goods (goods_num)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE Employee
	ADD FOREIGN KEY (post_id)
	REFERENCES Post (post_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE Goods_Task
	ADD FOREIGN KEY (task_id)
	REFERENCES Task (task_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE Task_Status
	ADD FOREIGN KEY (task_id)
	REFERENCES Task (task_id)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;



/* Comments */

COMMENT ON COLUMN Company.company_reg_num IS 'Регестрационный номер компании.';
COMMENT ON COLUMN Company.company_name IS 'Наименование компании.';
COMMENT ON COLUMN Company.work_status IS 'Статус компаниии: true - компнаия является клиентом и с ней уже заключен(ы) контракт(ы), false -компания является потециальный клиентом.';
COMMENT ON COLUMN Company.company_post_index IS 'Почтовый индекс компании.';
COMMENT ON COLUMN Company.company_address IS 'Адресс компании.';
COMMENT ON TABLE Contact_Person IS 'Контакное лицо. Представитель организации, т.е. клиента.';
COMMENT ON COLUMN Contact_Person.c_p_id IS 'Идентификатор контактного лица';
COMMENT ON COLUMN Contact_Person.company_reg_num IS 'Регестрационный номер компании.';
COMMENT ON COLUMN Contact_Person.c_p_phone_number IS 'Телефонный номер';
COMMENT ON COLUMN Contact_Person.c_p_email IS 'Адресс электронной почты.';
COMMENT ON COLUMN Contact_Person.c_p_first_name IS 'Имя контактного лица.';
COMMENT ON COLUMN Contact_Person.c_p_middle_name IS 'Отчество/второе имя контактного лица.';
COMMENT ON COLUMN Contact_Person.c_p_last_name IS 'Фамилия контактного лица';
COMMENT ON COLUMN Contract.contract_num IS 'Номер контракта';
COMMENT ON COLUMN Contract.contract_description  IS 'Описание контракта';
COMMENT ON COLUMN Employee.post_id IS 'Код должности сотрудника';
COMMENT ON COLUMN Employee.e_first_name IS 'Имя сотрудника';
COMMENT ON COLUMN Employee.e_middle_name IS 'Отчество сотрудника';
COMMENT ON COLUMN Employee.e_last_name IS 'Фамилия сотрудника';
COMMENT ON COLUMN Employee.e_email IS 'Адрес электронной почты';
COMMENT ON COLUMN Employee.e_phone_number IS 'Телефонный номер сотрудника';
COMMENT ON COLUMN Goods.goods_num IS 'Серийный номер товара';
COMMENT ON COLUMN Goods.goods_name IS 'Наименование товара
';
COMMENT ON COLUMN Goods.goods_decription IS 'Описание товара.';
COMMENT ON COLUMN Goods.contract_num IS 'Номер контракта';
COMMENT ON COLUMN Goods_Task.task_id IS 'Номер задания';
COMMENT ON COLUMN Goods_Task.goods_num IS 'Серийный номер товара';
COMMENT ON COLUMN Goods_Task.remark IS 'Примечание';
COMMENT ON COLUMN Post.post_id IS 'Код должности сотрудника';
COMMENT ON COLUMN Post.post_name IS 'Наименование должности сотрудника.';
COMMENT ON COLUMN Task.task_id IS 'Номер задания';
COMMENT ON COLUMN Task.c_p_id IS 'Идентификатор контактного лица';
COMMENT ON COLUMN Task.executor IS 'Исполнитель';
COMMENT ON COLUMN Task.creator IS 'Создатель';
COMMENT ON COLUMN Task.task_decription IS 'Описание задания.';
COMMENT ON COLUMN Task.task_create_datetime IS 'Дата создания задания';
COMMENT ON COLUMN Task.task_deadline_datetime IS 'Срок исполнения задания';
COMMENT ON COLUMN Task_Status.task_id IS 'Номер задания';
COMMENT ON COLUMN Task_Status.task_status_name IS 'Наименование статуса задания.';
COMMENT ON COLUMN Task_Status.task_completed_datetime IS 'Время выполнения задания. Заполняется после завершения заказа.';



