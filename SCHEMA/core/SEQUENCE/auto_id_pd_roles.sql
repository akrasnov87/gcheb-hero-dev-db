CREATE SEQUENCE core.auto_id_pd_roles
	START WITH 6
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE core.auto_id_pd_roles OWNER TO hero;
