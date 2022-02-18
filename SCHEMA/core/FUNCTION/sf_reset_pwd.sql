CREATE OR REPLACE FUNCTION core.sf_reset_pwd(_f_org bigint, _login text, _new_password text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
/** 
 * @params {bigint} _f_org - организация
 * @params {text} _login - логин
 * @params {text} _new_password - пароль
 * 
 * @returns {integer} - иден. пользователя
 */
DECLARE
	_b_hash boolean;
BEGIN
	select u.s_hash is not null into _b_hash
	from core.pd_users as u where u.c_login = _login and u.sn_delete = false;
	
	if _b_hash then
		update core.pd_users as u
		set s_hash = crypt(_new_password, gen_salt('bf')),
		c_password = null
		where u.c_login = _login and u.f_org = _f_org;

		return true;
	else
		update core.pd_users as u
		set c_password = _new_password,
		s_hash = null
		where u.c_login = _login and u.f_org = _f_org;

		return true;
	end if;
END
$$;

ALTER FUNCTION core.sf_reset_pwd(_f_org bigint, _login text, _new_password text) OWNER TO hero;

COMMENT ON FUNCTION core.sf_reset_pwd(_f_org bigint, _login text, _new_password text) IS 'Сброс пароля пользователя';
