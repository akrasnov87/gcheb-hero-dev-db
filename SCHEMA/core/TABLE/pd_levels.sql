CREATE TABLE core.pd_levels (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	f_parent uuid,
	c_name text NOT NULL,
	b_disabled boolean DEFAULT false NOT NULL,
	c_description text
);

ALTER TABLE core.pd_levels OWNER TO hero;

COMMENT ON TABLE core.pd_levels IS 'Уровени';

COMMENT ON COLUMN core.pd_levels.id IS 'Идентификатор';

COMMENT ON COLUMN core.pd_levels.f_parent IS 'Родитель';

COMMENT ON COLUMN core.pd_levels.c_name IS 'Наименование';

COMMENT ON COLUMN core.pd_levels.c_description IS 'Описание';

--------------------------------------------------------------------------------

CREATE TRIGGER pd_levels_log
	BEFORE INSERT OR UPDATE OR DELETE ON core.pd_levels
	FOR EACH ROW
	EXECUTE PROCEDURE core.sft_log_action();

--------------------------------------------------------------------------------

ALTER TABLE core.pd_levels
	ADD CONSTRAINT pd_levels_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE core.pd_levels
	ADD CONSTRAINT pd_levels_f_parent_fkey FOREIGN KEY (f_parent) REFERENCES core.pd_levels(id);
