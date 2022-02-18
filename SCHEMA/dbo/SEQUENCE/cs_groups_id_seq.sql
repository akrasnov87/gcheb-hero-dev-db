CREATE SEQUENCE dbo.cs_groups_id_seq
	AS integer
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE dbo.cs_groups_id_seq OWNER TO hero;

ALTER SEQUENCE dbo.cs_groups_id_seq
	OWNED BY dbo.cs_groups.id;
