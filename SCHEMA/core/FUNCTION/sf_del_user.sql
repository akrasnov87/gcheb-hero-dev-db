CREATE OR REPLACE FUNCTION core.sf_del_user(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from core.pd_userinroles
	where f_user = _id;

	delete from core.pd_users
	where id = _id;

	RETURN _id;
END
$$;

ALTER FUNCTION core.sf_del_user(_id bigint) OWNER TO hero;

COMMENT ON FUNCTION core.sf_del_user(_id bigint) IS 'Удаление пользователя';
