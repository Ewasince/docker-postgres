-- indexs
CREATE INDEX task_indx ON task(task_id);
CREATE INDEX task_status_indx ON task_status(task_id);
CREATE INDEX employee_indx ON employee(employee_id);
CREATE INDEX contact_person_indx ON contact_person(c_p_id);
CREATE INDEX company_indx ON company(company_reg_num);
CREATE INDEX contract_indx ON contract(contract_num);
CREATE INDEX goods_indx ON goods(goods_num);
CREATE INDEX goods_task_goods_num_indx ON goods_task(goods_num);
CREATE INDEX goods_task_task_id_indx ON goods_task(task_id);