CREATE TABLE dbo.dd_documents (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	c_first_name text NOT NULL,
	c_last_name text NOT NULL,
	c_middle_name text NOT NULL,
	d_birth_day date NOT NULL,
	d_death_day date,
	c_address text,
	c_text text,
	c_about text,
	f_category integer NOT NULL,
	f_group integer NOT NULL,
	f_storage uuid,
	b_disabled boolean DEFAULT true NOT NULL,
	dx_created timestamp without time zone DEFAULT now() NOT NULL,
	c_author text
);

ALTER TABLE dbo.dd_documents OWNER TO hero;

COMMENT ON COLUMN dbo.dd_documents.c_first_name IS 'Фамилие';

COMMENT ON COLUMN dbo.dd_documents.c_last_name IS 'Имя';

COMMENT ON COLUMN dbo.dd_documents.c_middle_name IS 'Отчество';

COMMENT ON COLUMN dbo.dd_documents.d_birth_day IS 'Дата рождения';

COMMENT ON COLUMN dbo.dd_documents.d_death_day IS 'Дата смерти';

COMMENT ON COLUMN dbo.dd_documents.c_address IS 'Адрес';

COMMENT ON COLUMN dbo.dd_documents.c_text IS 'Характеристика';

COMMENT ON COLUMN dbo.dd_documents.c_about IS 'Награды';

COMMENT ON COLUMN dbo.dd_documents.f_category IS 'Категория';

COMMENT ON COLUMN dbo.dd_documents.f_group IS 'Отрасль';

COMMENT ON COLUMN dbo.dd_documents.f_storage IS 'Ссылка на файл';

COMMENT ON COLUMN dbo.dd_documents.b_disabled IS 'Признак отключения';

COMMENT ON COLUMN dbo.dd_documents.dx_created IS 'Дата создания';

COMMENT ON COLUMN dbo.dd_documents.c_author IS 'Автор';

--------------------------------------------------------------------------------

CREATE TRIGGER dd_documents_log
	BEFORE INSERT OR UPDATE OR DELETE ON dbo.dd_documents
	FOR EACH ROW
	EXECUTE PROCEDURE core.sft_log_action();

--------------------------------------------------------------------------------

ALTER TABLE dbo.dd_documents
	ADD CONSTRAINT dd_documents_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE dbo.dd_documents
	ADD CONSTRAINT dd_documents_f_group_fkey FOREIGN KEY (f_group) REFERENCES dbo.cs_groups(id) NOT VALID;

--------------------------------------------------------------------------------

ALTER TABLE dbo.dd_documents
	ADD CONSTRAINT dd_documents_f_category_fkey FOREIGN KEY (f_category) REFERENCES dbo.cs_categories(id) NOT VALID;