CREATE TABLE core.sd_settings (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	c_key text NOT NULL,
	c_value text,
	c_summary text,
	c_type text DEFAULT 'TEXT'::text NOT NULL,
	sn_delete boolean DEFAULT false NOT NULL
);

ALTER TABLE core.sd_settings OWNER TO hero;

COMMENT ON TABLE core.sd_settings IS 'Основные настройки';

COMMENT ON COLUMN core.sd_settings.id IS 'Идентификатор';

COMMENT ON COLUMN core.sd_settings.c_key IS 'Ключ';

COMMENT ON COLUMN core.sd_settings.c_value IS 'Значение';

COMMENT ON COLUMN core.sd_settings.c_summary IS 'Описание настройки';

COMMENT ON COLUMN core.sd_settings.c_type IS 'Тип данных: TEXT, INT, BOOL, DATE';

COMMENT ON COLUMN core.sd_settings.sn_delete IS 'Признак удаления';

--------------------------------------------------------------------------------

CREATE TRIGGER cd_settings_log
	BEFORE INSERT OR UPDATE OR DELETE ON core.sd_settings
	FOR EACH ROW
	EXECUTE PROCEDURE core.sft_log_action();

--------------------------------------------------------------------------------

ALTER TABLE core.sd_settings
	ADD CONSTRAINT cd_settings_pkey PRIMARY KEY (id);
