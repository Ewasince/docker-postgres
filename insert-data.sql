INSERT INTO company(company_reg_num, company_name, work_status, company_post_index, company_address)
VALUES
(111122223333, 'OOO ТРИ КОЙЛА', true, '123123', 'Г. Москва ул. Пушкина-Колотушкина д.2'),
(111122224444, 'ООО ТЯП-ЛЯП', true, '321321', 'г. Санкт-Питерсбург ул. Солевая д.10'),
(111122225555, 'ОАО БАЛАМУТ и ОБОРМОТ', 'false', '312312', 'г. Самара ул. Ленина д.15');


 -- Вставка данных  в contact_person
INSERT INTO contact_person(c_p_id, company_reg_num, c_p_phone_number, c_p_email, c_p_first_name, c_p_middle_name, c_p_last_name)
VALUES 
(101, 111122223333, 89661880398, 'zaec@yandex.ru', 'Anton', 'Genadievich', 'Lopata'),
(102, 111122223333, 89661142233, 'volk@mail.ru', 'Ivan', 'Semenovich', 'Sglipa'),
(103, 111122224444, 88005353536, 'korneplod228@mail.ru', 'Viktor', 'Mstislavovich', 'Korneplod'),
(104, 111122224444, 89661337228, 'boec_stalnoi_stalker@gmail.com', 'Sharhan', 'Uzbecovich', 'Kopatich'),
(105, 111122225555, 89671156772, 'svin@yahoo.com', 'Zholud', 'Poddubovich', 'Hryak');


-- Вставка данных о контрактах
INSERT INTO contract(contract_num, contract_description)
VALUES
(101010, 'holodilnik dlya lupi i pupi'),
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


-- workers
CALL add_employee('salaga', 'Artem', 'Mihailovich', 'Anichkov', 'Dedmercy@yandex.ru', 88005353535, 'dedmercy', '123');
CALL add_employee('salaga', 'Vladislav', 'Iliich', 'Lavrenov', 'Ewasinse@gmail.ru', 88005353537, 'ewasince', '124');
CALL add_employee('manager', 'VAN', 'DER', 'HOLE', 'dangeonmaster@yandex.ru', 88005352000, 'prettyboy', '125');
CALL add_employee('manager', 'Vitali', 'Olegovich', 'Gromyako', 'ezforpapich@yandex.ru', 88005352000, 'evilarthas', '126');

-- ! Посмотреть перед закидыванием таска oid роли !

-- Insert into Task
CALL create_task(11111002, 101, 16546, 'some description', '2022-12-10 10:00:00'::TIMESTAMP WITHOUT TIME ZONE, 10::smallint, 102);


-- Export Func
CALL export_csv(16546, 
				'2022-11-01 10:00:00'::TIMESTAMP WITHOUT TIME ZONE TIMESTAMP, 
				'2022-11-31 10:00:00'::TIMESTAMP WITHOUT TIME ZONE TIMESTAMP) 