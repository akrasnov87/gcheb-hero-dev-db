CREATE OR REPLACE FUNCTION core.sf_remove_outdated() RETURNS void
    LANGUAGE plpgsql
    AS $$
/**
* системная функция должна выполнять от postgres
*/
DECLARE
    _n_val      integer = 100;
	_dg_cnt		integer; --diagnostic
	_dg_text	text = '';
BEGIN

    -- опрос настройки
    BEGIN
        select
            c_value::integer
        into _n_val
        from core.sd_settings
        where c_key = 'ALL_DEL_AFTER';

    --в любых непонятных ситуациях берем 100 дней
    EXCEPTION
        WHEN OTHERS
        THEN _n_val = 100;
    END;

	delete from core.sd_action_log where (d_date  + (_n_val * '1 day'::interval)) < now();
	get diagnostics _dg_cnt = row_count;
	_dg_text = _dg_text || now()::text || ' core.sd_action_log: удалено '|| _dg_cnt::text || E'\n';

	perform core.sf_write_log('Очистка таблиц выполнена. ' || E'\n' || _dg_text, null, 0);
	
	EXCEPTION
	WHEN OTHERS
    THEN
		perform core.sf_write_log('Непредвиденная ошибка очистки таблиц. ' || E'\n' || _dg_text, null, 1);

END;
$$;

ALTER FUNCTION core.sf_remove_outdated() OWNER TO postgres;

COMMENT ON FUNCTION core.sf_remove_outdated() IS 'Процедура очистки устаревших данных';
