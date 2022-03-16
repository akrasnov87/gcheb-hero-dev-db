CREATE OR REPLACE FUNCTION dbo.of_search(_sender jsonb, _c_name text, _n_month integer, _f_category integer, _f_group integer) RETURNS TABLE(id uuid, c_first_name text, c_last_name text, c_middle_name text, d_birth_day date, c_author text, c_content text, c_about text, f_category integer, c_category text, c_category_name text, f_group integer, c_group text, c_group_name text, c_image_path text)
    LANGUAGE plpgsql
    AS $$
/**
 * @params {jsonb} _sender - информация об авторизованном пользователе
 * @params {text} _c_name - ФИО
 * @params {integer} _n_month - номер месяца для фильтрации
 * @params {integer} _f_category - категория
 * @params {integer} _f_group - отрасль
 * 
 * example
 * [{"action": "of_search", "method": "Select", "data": [{"params": ['Кирилл', 1, 1, 1] }], "type": "rpc", "tid": 0}]
 * Поиск людей, у которых в части имени есть 'Кирилл', месяц рождения январь, категория - Выдающиеся земляки, отрасль - Экономика
 *
 * [{"action": "of_search", "method": "Select", "data": [{"params": [null, 1, null, null] }], "type": "rpc", "tid": 0}]
 * Получение людей, у которые день рождение в январе
 */
BEGIN
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
	and (case when _c_name is null then 1=1 else d.c_first_name ilike '%' || _c_name || '%' end 
	or case when _c_name is null then 1=1 else d.c_last_name ilike '%' || _c_name || '%' end
	or case when _c_name is null then 1=1 else d.c_middle_name ilike '%' || _c_name || '%' end)
	and case when _f_category is null then 1=1 else c.id = _f_category end 
	and case when _f_group is null then 1=1 else g.id = _f_group end
	and case when _n_month is null then 1=1 else date_part('month', d.d_birth_day) = _n_month end
	order by d.d_birth_day, d.c_first_name, d.c_last_name, d.c_middle_name;
END;
$$;

ALTER FUNCTION dbo.of_search(_sender jsonb, _c_name text, _n_month integer, _f_category integer, _f_group integer) OWNER TO gcheb;

COMMENT ON FUNCTION dbo.of_search(_sender jsonb, _c_name text, _n_month integer, _f_category integer, _f_group integer) IS 'Поиск по части имени с фильтрацией по месяцу, отрасли и категории';
