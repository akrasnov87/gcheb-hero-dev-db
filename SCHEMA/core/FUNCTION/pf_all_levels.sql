CREATE OR REPLACE FUNCTION core.pf_all_levels(_f_parent uuid) RETURNS TABLE(id uuid, c_text text, b_leaf boolean, f_parent uuid, c_description text, c_imp_id integer)
    LANGUAGE plpgsql
    AS $$
/**
* @params {uuid} _f_parent - родительский элемент
*/
BEGIN
	RETURN QUERY
	WITH RECURSIVE included_levels(f_parent, id) AS (
		select l.f_parent, l.id
		from core.pd_levels as l 
		where l.id = _f_parent
		union all
		select l.f_parent, l.id
		from core.pd_levels as l, included_levels as il 
		where l.f_parent = il.id
	)
	select l.id, l.c_name, (select count(*) = 0 from core.pd_levels as t where t.f_parent = l.id) as b_leaf,
	l.f_parent, l.c_description, l.c_imp_id
	from core.pd_levels as l
	where l.b_disabled = false 
	and (case when _f_parent is null then 1=1 else l.id in (select t.id from included_levels as t) end)
	order by l.c_name;
END;
$$;

ALTER FUNCTION core.pf_all_levels(_f_parent uuid) OWNER TO hero;

COMMENT ON FUNCTION core.pf_all_levels(_f_parent uuid) IS 'Получение информации о всех уровнях';
