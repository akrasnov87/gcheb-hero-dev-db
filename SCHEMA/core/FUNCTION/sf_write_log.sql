CREATE OR REPLACE FUNCTION core.sf_write_log(_c_message text, _c_data text, _n_level integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
/**
 * @params {text} _c_message - текст лога
 * @params {integer} _n_level - уровень логирования, 0 - сообщение, 1 - ошибка
 */
BEGIN
	insert into core.sd_sys_log(n_level_msg, c_data, dx_created, c_description)
	values (_n_level, _c_data, now(), _c_message);
END
$$;

ALTER FUNCTION core.sf_write_log(_c_message text, _c_data text, _n_level integer) OWNER TO hero;

COMMENT ON FUNCTION core.sf_write_log(_c_message text, _c_data text, _n_level integer) IS 'Запись логов';
