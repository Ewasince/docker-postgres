 -- Вставка данных  в contact_person
INSERT INTO contact_person(c_p_id, company_reg_num, c_p_phone_number, c_p_email, c_p_first_name, c_p_middle_name, c_p_last_name)
VALUES 
(101, 111122223333, 89661880398, 'zaec@yandex.ru', 'Anton', 'Genadievich', 'Lopata'),
(102, 111122223333, 89661142233, 'volk@mail.ru', 'Ivan', 'Semenovich', 'Sglipa'),
(103, 111122224444, 88005353536, 'korneplod228@mail.ru', 'Viktor', 'Mstislavovich', 'Korneplod'),
(104, 111122224444, 89661337228, 'boec_stalnoi_stalker@gmail.com', 'Sharhan', 'Uzbecovich', 'Kopatich'),
(105, 111122225555, 89671156772, 'svin@yahoo.com', 'Zholud', 'Poddubovich', 'Hryak');

INSERT INTO company(company_reg_num, company_name, work_status, company_post_index, company_address)
VALUES
(111122223333, 'OOO ТРИ КОЙЛА', true, '123123', 'Г. Москва ул. Пушкина-Колотушкина д.2'),
(111122224444, 'ООО ТЯП-ЛЯП', true, '321321', 'г. Санкт-Питерсбург ул. Солевая д.10'),
(111122225555, 'ОАО БАЛАМУТ и ОБОРМОТ', 'false', '312312', 'г. Самара ул. Ленина д.15');

-- Вставка данных о контрактах
INSERT INTO contract(contract_num, contract_description)
VALUES
(101010, 'contract1'),
(101011, 'contract2'),
(101012, 'contract3');

--	Вставка данных о товарах
INSERT INTO goods(goods_num, goods_name, goods_decription, contract_num)
VALUES
(100, 'Холодильная камера 3000', 'Полный отморозок', 101010),
(101, 'Токарный станок "Убивец"', 'Режет как по маслу', 101011),
(102, 'Пылесос', 'Просто пылесос', 101011),
(103, 'Перфоратор', 'Нормально долбит', 101010),
(104, 'Лобзик', 'Вроде пилит', 101012),
(105, 'Пылесос mk2', 'Не просто пылесос', 101012),
(106, 'Пудж',  'Имба патча', 101010);

--Вставка данных post
	INSERT INTO post(post_id, post_name)
	VALUES
	(to_regrole('salaga'), 'salaga'),
	(to_regrole('manager'), 'manager'),
	(to_regrole('admin'), 'admin');