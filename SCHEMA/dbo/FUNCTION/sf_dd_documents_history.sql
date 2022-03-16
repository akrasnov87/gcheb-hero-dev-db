CREATE OR REPLACE FUNCTION dbo.sf_dd_documents_history(_id uuid) RETURNS TABLE(c_operation text, jb_old_value jsonb, jb_new_value jsonb, d_date timestamp without time zone)
    LANGUAGE plpgsql STABLE
    AS $$
/**
* @params {uuid} _id - идентификатор
*
* @example
* [{ "action": "of_dd_documents_history", "method": "Select", "data": [{ "params": [_id] }], "type": "rpc", "tid": 0 }]
*/
BEGIN
	return query select l.c_operation, l.jb_old_value, l.jb_new_value, l.dx_created
	from core.sd_action_log as l
	where l.c_table_name = 'dd_documents' and (l.jb_new_value->>'id') = _id::text
	order by l.d_date desc;
END
$$;

ALTER FUNCTION dbo.sf_dd_documents_history(_id uuid) OWNER TO gcheb;

COMMENT ON FUNCTION dbo.sf_dd_documents_history(_id uuid) IS 'История изменения документа (человека)';
