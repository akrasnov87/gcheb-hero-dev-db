CREATE TABLE dbo.cs_groups (
	id integer DEFAULT nextval('dbo.cs_groups_id_seq'::regclass) NOT NULL,
	c_name text NOT NULL,
	c_const text NOT NULL,
	n_order integer NOT NULL
);

ALTER TABLE dbo.cs_groups OWNER TO gcheb;

COMMENT ON TABLE dbo.cs_groups IS 'Отрасль';

--------------------------------------------------------------------------------

ALTER TABLE dbo.cs_groups
	ADD CONSTRAINT cs_groups_pkey PRIMARY KEY (id);
