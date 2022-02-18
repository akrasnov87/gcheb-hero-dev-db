START TRANSACTION;

insert into core.pd_roles (id, c_name, c_description, n_weight) values 
(-1, 'anonymous', 'Анонимный', 0), -- -1
(1, 'admin', 'Администратор', 1000), -- 1
(2, 'user', 'Пользователь', 900); -- 2

COMMIT TRANSACTION;