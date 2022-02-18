CREATE OR REPLACE FUNCTION core.sf_level_users(_f_level uuid) RETURNS TABLE(id bigint, c_login text, b_disabled boolean, d_created_date timestamp without time zone, d_change_date timestamp without time zone, c_about text, c_first_name text, c_middle_name text, c_last_name text, c_post text, c_imp_id text, d_last_auth_date timestamp without time zone, f_level uuid, c_level text, c_notice text, c_created_user text, c_change_user text, c_role_name text, c_role_description text, c_phone text, c_email text, c_address text, f_photo uuid)
    LANGUAGE plpgsql
    AS $$
/**
* @params {uuid} _f_level - иден. уровня
*/
BEGIN
	
	return query 
	WITH RECURSIVE included_levels(f_parent, id) AS (
		select l.f_parent, l.id
		from core.pd_levels as l 
		where l.id = _f_level
		union all
		select l.f_parent, l.id
		from core.pd_levels as l, included_levels as il 
		where l.f_parent = il.id
	)
	select 
	u.id,
	u.c_login,
	u.b_disabled,
	u.d_created_date,
	u.d_change_date,
	u.c_about,
	u.c_first_name,
	u.c_middle_name,
	u.c_last_name,
	u.c_post,
	u.c_imp_id,
	u.d_last_auth_date,
	u.f_level,
	l.c_name,
	u.c_notice,
	u.c_created_user,
	u.c_change_user,
	'.' || string_agg(pr.c_name, '.') || '.' as c_role_name, 
	string_agg(pr.c_description , ',') 		as c_role_description,
	u.c_phone,
	u.c_email,
	u.c_address,
	u.f_photo 
   FROM core.pd_users u
   inner join core.pd_userinroles pur 
   	on u.id = pur.f_user 
   inner join core.pd_roles pr 
	on pr.id = pur.f_role 
   left join core.pd_levels as l on u.f_level = l.id
   WHERE u.sn_delete = false 
   and case when _f_level is null then 1=1 else u.f_level in (select t.id from included_levels as t) end
  	group by u.id, l.c_name
   ;
END;
$$;

ALTER FUNCTION core.sf_level_users(_f_level uuid) OWNER TO hero;

COMMENT ON FUNCTION core.sf_level_users(_f_level uuid) IS 'Получение информации о пользователях на уровне';
