INSERT INTO company(company_reg_num, company_name, work_status, company_post_index, company_address)
VALUES
(111122223333, 'OOO ��� �����', true, '123123', '�. ������ ��. �������-����������� �.2'),
(111122224444, '��� ���-���', true, '321321', '�. �����-���������� ��. ������� �.10'),
(111122225555, '��� ������� � �������', 'false', '312312', '�. ������ ��. ������ �.15');


 -- ������� ������  � contact_person
INSERT INTO contact_person(c_p_id, company_reg_num, c_p_phone_number, c_p_email, c_p_first_name, c_p_middle_name, c_p_last_name)
VALUES 
(101, 111122223333, 89661880398, 'zaec@yandex.ru', 'Anton', 'Genadievich', 'Lopata'),
(102, 111122223333, 89661142233, 'volk@mail.ru', 'Ivan', 'Semenovich', 'Sglipa'),
(103, 111122224444, 88005353536, 'korneplod228@mail.ru', 'Viktor', 'Mstislavovich', 'Korneplod'),
(104, 111122224444, 89661337228, 'boec_stalnoi_stalker@gmail.com', 'Sharhan', 'Uzbecovich', 'Kopatich'),
(105, 111122225555, 89671156772, 'svin@yahoo.com', 'Zholud', 'Poddubovich', 'Hryak');


-- ������� ������ � ����������
INSERT INTO contract(contract_num, contract_description)
VALUES
(101010, 'holodilnik dlya lupi i pupi'),
(101011, 'contract2'),
(101012, 'contract3');


--	������� ������ � �������
INSERT INTO goods(goods_num, goods_name, goods_decription, contract_num)
VALUES
(100, '����������� ������ 3000', '������ ���������', 101010),
(101, '�������� ������ "������"', '����� ��� �� �����', 101011),
(102, '�������', '������ �������', 101011),
(103, '����������', '��������� ������', 101010),
(104, '������', '����� �����', 101012),
(105, '������� mk2', '�� ������ �������', 101012),
(106, '����',  '���� �����', 101010);


--������� ������ post
INSERT INTO post(post_id, post_name)
VALUES
(to_regrole('salaga'), 'salaga'),
(to_regrole('manager'), 'manager'),
(to_regrole('admin'), 'admin');

INSERT INTO employee(employee_id, post_id, e_first_name, e_last_name, e_email, e_phone_number, e_nickname)
VALUES (to_regrole('admin'), to_regrole('admin'), 'Viktor', 'Korneplod', 'derevo@gmail.com', 88005353535, 'admin')


-- workers
CALL add_employee('salaga', 'Artem', 'Mihailovich', 'Anichkov', 'Dedmercy@yandex.ru', 88005353535, 'dedmercy', '123');
CALL add_employee('salaga', 'Vladislav', 'Iliich', 'Lavrenov', 'Ewasinse@gmail.ru', 88005353537, 'ewasince', '124');
CALL add_employee('manager', 'VAN', 'DER', 'HOLE', 'dangeonmaster@yandex.ru', 88005352000, 'prettyboy', '125');
CALL add_employee('manager', 'Vitali', 'Olegovich', 'Gromyako', 'ezforpapich@yandex.ru', 88005352000, 'evilarthas', '126');

-- ! ���������� ����� ������������ ����� oid ���� !

SELECT * FROM employee;





SET ROLE prettyboy;

-- Insert into Task
CALL create_task(11111002, 101, 16549, 'some description in_process', '2022-12-10 10:00:00'::TIMESTAMP WITHOUT TIME ZONE, 10::smallint, 102);
CALL create_task(11111003, 102, 16549, 'some description2 in_process', '2022-12-12 10:00:00'::TIMESTAMP WITHOUT TIME ZONE, 10::smallint, 101);
CALL create_task(11111005, 102, 16549, 'some description5 in_time', '2022-12-13 10:00:00'::TIMESTAMP WITHOUT TIME ZONE, 10::smallint, 104);
CALL create_task(11111006, 104, 16549, 'some description6 out_time', '2022-10-12 10:00:00'::TIMESTAMP WITHOUT TIME ZONE, 10::smallint, 100);
CALL create_task(11111007, 105, 16549, 'super task', '2022-10-13 10:00:00'::TIMESTAMP WITHOUT TIME ZONE, 10::smallint, 103);
CALL create_task(11111008, 103, 16549, 'prosto task', '2022-11-12 10:00:00'::TIMESTAMP WITHOUT TIME ZONE, 10::smallint, 105);
CALL create_task(11111009, 101, 16549, 'pochinit stanok', '2022-10-12 10:00:00'::TIMESTAMP WITHOUT TIME ZONE, 10::smallint, 102);
CALL create_task(11111010, 105, 16549, 'kupit arkany', '2022-12-02 10:00:00'::TIMESTAMP WITHOUT TIME ZONE, 10::smallint, 106);

RESET ROLE;

SET ROLE dedmercy;

CALL complete_task(11111006);
CALL complete_task(11111005);

RESET ROLE;

SELECT * FROM export(16549, 
'2022-11-01 10:00:00'::TIMESTAMP WITHOUT TIME ZONE, 
'2022-11-30 10:00:00'::TIMESTAMP WITHOUT TIME ZONE);


-- Export Func
CALL export_csv(16549, 
				'2022-11-01 10:00:00'::TIMESTAMP WITHOUT TIME ZONE, 
				'2022-11-30 10:00:00'::TIMESTAMP WITHOUT TIME ZONE);
				
-- Export Func json
CALL export_json(16549, 
				'	2022-11-01 10:00:00'::TIMESTAMP WITHOUT TIME ZONE, 
				'2022-11-30 10:00:00'::TIMESTAMP WITHOUT TIME ZONE,
				'worker1');
				
-- Export Func json2
CALL export_json(16549, 
				'2022-11-01 10:00:00'::TIMESTAMP WITHOUT TIME ZONE, 
				'2022-11-30 10:00:00'::TIMESTAMP WITHOUT TIME ZONE);