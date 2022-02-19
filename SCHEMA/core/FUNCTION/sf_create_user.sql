CREATE OR REPLACE FUNCTION core.sf_create_user(_login text, _password text, _claims text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
/**
 * @params {text} _login - логин
 * @params {text} _password - пароль
 * @params {text} _claims - роли,  в формате JSON, например ["admin", "master"]
 * 
 * @returns {integer} - иден. пользователя
 */
DECLARE
	_f_user integer;
BEGIN
	insert into core.pd_users(c_login, c_password, s_hash)
	values (_login, null, crypt(_password, gen_salt('bf'))) RETURNING id INTO _f_user;
	
	perform core.pf_update_user_roles(_f_user, _claims::json);
	
	RETURN _f_user;
END
$$;

ALTER FUNCTION core.sf_create_user(_login text, _password text, _claims text) OWNER TO gcheb;

COMMENT ON FUNCTION core.sf_create_user(_login text, _password text, _claims text) IS 'Создание пользователя с определенными ролями';
