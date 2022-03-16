CREATE OR REPLACE FUNCTION dbo.of_current_day(_sender jsonb) RETURNS TABLE(id uuid, c_first_name text, c_last_name text, c_middle_name text, d_birth_day date, c_author text, c_content text, c_about text, f_category integer, c_category text, c_category_name text, f_group integer, c_group text, c_group_name text, c_image_path text)
    LANGUAGE plpgsql
    AS $$
/**
 * @params {jsonb} _sender - информация об авторизованном пользователе
 * 
 * example
 * [{"action": "of_current_day", "method": "Select", "data": [{"params": [] }], "type": "rpc", "tid": 0}]
 * Поиск людей, у которых ближайшее день рождение
 */
DECLARE
	_n_month integer;	-- месяц для фильтрации
	_n_day integer;		-- день для фильтрации
BEGIN
	select date_part('month', d.d_birth_day), date_part('day', d.d_birth_day) into _n_month, _n_day from dbo.dd_documents as d
	group by d.d_birth_day
	order by d.d_birth_day
	limit 1;
	
	return query 
		select 
		d.id, 															-- иден. документа
		d.c_first_name, 												-- Фамилие
		d.c_last_name, 													-- Имя
		d.c_middle_name, 												-- Отчество
		d.d_birth_day,													-- Дата рождения
		coalesce(u.c_name, 'Администрация города Чебоксар') as c_author,-- Автор
		d.c_text as c_content,											-- Характеристика
		d.c_about,														-- Награды
		d.f_category,													-- Категория
		c.c_const as c_category,
		c.c_name as c_category_name,
		d.f_group,														-- Отрасль
		g.c_const as c_group,
		g.c_name as c_group_name,
		d.c_image_path
	from dbo.dd_documents as d
	inner join dbo.cs_categories as c on c.id = d.f_category 
	inner join dbo.cs_groups as g on g.id = d.f_group 
	left join core.pd_users as u on d.f_user = u.id
	where d.b_disabled = false 
	and date_part('month', d.d_birth_day) = _n_month
	and date_part('day', d.d_birth_day) = _n_day
	order by d.d_birth_day, d.c_first_name, d.c_last_name, d.c_middle_name;
END;
$$;

ALTER FUNCTION dbo.of_current_day(_sender jsonb) OWNER TO gcheb;

COMMENT ON FUNCTION dbo.of_current_day(_sender jsonb) IS 'Ближайшие именники на текущий день';
