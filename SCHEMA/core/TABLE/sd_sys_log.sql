CREATE TABLE core.sd_sys_log (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	n_level_msg integer DEFAULT 0,
	dx_created timestamp without time zone,
	c_description text,
	c_data text
);

ALTER TABLE core.sd_sys_log OWNER TO gcheb;

COMMENT ON TABLE core.sd_sys_log IS 'Системное логирование';

COMMENT ON COLUMN core.sd_sys_log.id IS 'Идентификатор';

COMMENT ON COLUMN core.sd_sys_log.n_level_msg IS '0 - сообщение
1 - ошибка';

COMMENT ON COLUMN core.sd_sys_log.dx_created IS 'Дата создания';

COMMENT ON COLUMN core.sd_sys_log.c_description IS 'Описание';

COMMENT ON COLUMN core.sd_sys_log.c_data IS 'Дополнительные данные';

--------------------------------------------------------------------------------

ALTER TABLE core.sd_sys_log
	ADD CONSTRAINT cd_sys_log_pkey PRIMARY KEY (id);
