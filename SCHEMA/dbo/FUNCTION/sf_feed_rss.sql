CREATE OR REPLACE FUNCTION dbo.sf_feed_rss(_c_category text, _n_month integer) RETURNS TABLE(id uuid, c_first_name text, c_last_name text, c_middle_name text, d_pub_date date, c_author text, c_category text, c_content text, c_about text)
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} _c_category - константа из таблицы cs_groups
* @params {integer} _n_month - номер месяца для фильтрации именниников
*/
BEGIN
	return query 
		select 
		d.id, 
		d.c_first_name, 
		d.c_last_name, 
		d.c_middle_name, 
		coalesce(d.d_change_date, d.d_created_date)::date as d_pub_date,
		coalesce(u.c_name, 'Администрация города Чебоксар') as c_author,
		g.c_name as c_category,
		d.c_text as c_content,
		d.c_about
	from dbo.dd_documents as d
	inner join dbo.cs_groups as g on g.id = d.f_group 
	left join core.pd_users as u on d.f_user = u.id
	where d.b_disabled = false and case when _c_category is null then 1=1 else g.c_const = _c_category end 
	and case when _n_month is null then 1=1 else date_part('month', d.d_birth_day) = _n_month end
	order by d.c_first_name, d.c_last_name, d.c_middle_name, d.d_birth_day;
END;
$$;

ALTER FUNCTION dbo.sf_feed_rss(_c_category text, _n_month integer) OWNER TO gcheb;

COMMENT ON FUNCTION dbo.sf_feed_rss(_c_category text, _n_month integer) IS 'Информация для RSS ленты';
