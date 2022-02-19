CREATE OR REPLACE FUNCTION core.sft_log_action() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (TG_OP = 'UPDATE') THEN
		INSERT INTO core.sd_action_log(c_table_name, c_operation, jb_old_value, jb_new_value, c_user, d_date)
		VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW), USER, CURRENT_DATE);
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
		INSERT INTO core.sd_action_log(c_table_name, c_operation, jb_old_value, c_user, d_date)
		VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), USER, CURRENT_DATE);
        RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO core.sd_action_log(c_table_name, c_operation, jb_new_value, c_user, d_date)
		VALUES (TG_TABLE_NAME, TG_OP, row_to_json(NEW), USER, CURRENT_DATE);
	    RETURN NEW;
    ELSE
        RETURN OLD;
	END IF;

EXCEPTION
	WHEN OTHERS
    THEN
		INSERT INTO core.cd_sys_log(d_timestamp, c_descr)
		VALUES(clock_timestamp(), 'Непредвиденная ошибка логирования');
    RETURN OLD;
END;
$$;

ALTER FUNCTION core.sft_log_action() OWNER TO gcheb;

COMMENT ON FUNCTION core.sft_log_action() IS 'Триггер. Процедура логирования действия пользователя';
