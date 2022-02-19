CREATE TABLE dbo.cs_categories (
	id integer DEFAULT nextval('dbo.cs_categories_id_seq'::regclass) NOT NULL,
	c_name text NOT NULL,
	c_const text NOT NULL,
	n_order integer NOT NULL
);

ALTER TABLE dbo.cs_categories OWNER TO gcheb;

COMMENT ON TABLE dbo.cs_categories IS 'Отрасль';

--------------------------------------------------------------------------------

ALTER TABLE dbo.cs_categories
	ADD CONSTRAINT cs_categories_pkey PRIMARY KEY (id);
