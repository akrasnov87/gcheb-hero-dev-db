CREATE OR REPLACE FUNCTION core.sf_update_pwd(_login text, _password text, _new_password text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
/**
 * @params {text} _login - логин
 * @params {text} _password - пароль
 * 
 * @returns {integer} - иден. пользователя
 */
DECLARE
	_b_verify boolean;
	_b_hash boolean;
BEGIN
	select 
		case when u.s_hash is null 
			then u.c_password = _password 
			else crypt(_password, u.s_hash) = u.s_hash 
		end, u.s_hash is not null into _b_verify, _b_hash
	from core.pd_users as u where u.c_login = _login and u.b_disabled = false and u.sn_delete = false;
	
	if _b_verify then 
		if _b_hash then
			update core.pd_users as u
			set s_hash = crypt(_new_password,gen_salt('bf')),
			c_password = null
			where u.c_login = _login;
			
			return true;
		else
			update core.pd_users as u
			set c_password = _new_password,
			s_hash = null
			where u.c_login = _login;
			
			return true;
		end if;
	end if;
	
	return false;
END
$$;

ALTER FUNCTION core.sf_update_pwd(_login text, _password text, _new_password text) OWNER TO hero;

COMMENT ON FUNCTION core.sf_update_pwd(_login text, _password text, _new_password text) IS 'Замена пароля пользователя';
