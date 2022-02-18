CREATE OR REPLACE FUNCTION core.pf_levels(_f_parent uuid) RETURNS TABLE(id uuid, c_text text, b_leaf boolean, f_parent uuid, c_description text, c_imp_id integer)
    LANGUAGE plpgsql
    AS $$
/**
* @params {uuid} _f_parent - родительский элемент
* @params {bigint} _f_org - идентификатор организации
*/
BEGIN
	RETURN QUERY select l.id, l.c_name, (select count(*) = 0 from core.pd_levels as t where t.f_parent = l.id) as b_leaf,
	l.f_parent, l.c_description, l.c_imp_id
	from core.pd_levels as l
	where l.b_disabled = false 
	and case when _f_parent is null then l.f_parent is null else l.f_parent = _f_parent end
	order by l.c_name;
END;
$$;

ALTER FUNCTION core.pf_levels(_f_parent uuid) OWNER TO hero;

COMMENT ON FUNCTION core.pf_levels(_f_parent uuid) IS 'Получение информации о уровнях';
