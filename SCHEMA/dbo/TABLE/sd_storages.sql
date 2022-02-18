CREATE TABLE dbo.sd_storages (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	c_name text NOT NULL,
	n_length integer NOT NULL,
	d_date date NOT NULL,
	c_dir text NOT NULL,
	c_mime text NOT NULL
);

ALTER TABLE dbo.sd_storages OWNER TO hero;

COMMENT ON COLUMN dbo.sd_storages.c_name IS 'Имя элемента';

COMMENT ON COLUMN dbo.sd_storages.n_length IS 'Место занимаемое в файловой системе';

COMMENT ON COLUMN dbo.sd_storages.d_date IS 'Дата создания';

COMMENT ON COLUMN dbo.sd_storages.c_dir IS 'Директория';

--------------------------------------------------------------------------------

CREATE TRIGGER sd_storages_log
	BEFORE INSERT OR UPDATE OR DELETE ON dbo.sd_storages
	FOR EACH ROW
	EXECUTE PROCEDURE core.sft_log_action();

--------------------------------------------------------------------------------

ALTER TABLE dbo.sd_storages
	ADD CONSTRAINT sd_storages_pkey PRIMARY KEY (id);
