CREATE OR REPLACE FUNCTION core.sf_verify_user(_login text, _password text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
/**
 * @params {text} _login - логин
 * @params {text} _password - пароль
 * 
 * @returns {bigint} - иден. пользователя
 */
DECLARE
	_f_user 	bigint;
BEGIN
	select (case when t.b_verify then t.id else -1 end) into _f_user from (select 
		case when u.s_hash is null 
			then u.c_password = _password 
			else crypt(_password, u.s_hash) = u.s_hash 
		end as b_verify,
		u.id
	from core.pd_users as u 
	where u.c_login = _login and u.b_disabled = false and u.sn_delete = false) as t;
	
	return _f_user;
END
$$;

ALTER FUNCTION core.sf_verify_user(_login text, _password text) OWNER TO gcheb;

COMMENT ON FUNCTION core.sf_verify_user(_login text, _password text) IS 'Проверка пользователя на авторизацию';
