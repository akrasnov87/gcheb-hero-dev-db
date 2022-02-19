CREATE TABLE core.pd_users (
	id bigint DEFAULT nextval('core.auto_id_pd_users'::regclass) NOT NULL,
	c_login text NOT NULL,
	c_password text,
	s_hash text,
	c_name text,
	d_last_auth_date timestamp without time zone,
	c_notice text,
	c_email text,
	f_level uuid,
	d_last_change_password timestamp without time zone,
	b_disabled boolean DEFAULT false NOT NULL,
	sn_delete boolean DEFAULT false NOT NULL
);

ALTER TABLE core.pd_users OWNER TO gcheb;

COMMENT ON TABLE core.pd_users IS 'Пользователи / Организации';

COMMENT ON COLUMN core.pd_users.id IS 'Идентификатор';

COMMENT ON COLUMN core.pd_users.c_login IS 'Логин';

COMMENT ON COLUMN core.pd_users.c_password IS 'Пароль';

COMMENT ON COLUMN core.pd_users.s_hash IS 'Hash';

COMMENT ON COLUMN core.pd_users.c_name IS 'Наименование';

COMMENT ON COLUMN core.pd_users.d_last_auth_date IS 'Дата последней авторизации';

COMMENT ON COLUMN core.pd_users.c_notice IS 'Примечание, которое указывается администратором ';

COMMENT ON COLUMN core.pd_users.c_email IS 'Адрес электронной почты';

COMMENT ON COLUMN core.pd_users.f_level IS 'Уровень: филиал / отделение / участок';

COMMENT ON COLUMN core.pd_users.d_last_change_password IS 'Дата изменения пароля';

COMMENT ON COLUMN core.pd_users.b_disabled IS 'Отключен';

COMMENT ON COLUMN core.pd_users.sn_delete IS 'Удален';

--------------------------------------------------------------------------------

CREATE INDEX pd_users_b_disabled_sn_delete_idx ON core.pd_users USING btree (b_disabled, sn_delete);

--------------------------------------------------------------------------------

CREATE TRIGGER pd_users_log
	BEFORE INSERT OR UPDATE OR DELETE ON core.pd_users
	FOR EACH ROW
	EXECUTE PROCEDURE core.sft_log_action();

--------------------------------------------------------------------------------

ALTER TABLE core.pd_users
	ADD CONSTRAINT pd_users_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE core.pd_users
	ADD CONSTRAINT pd_users_uniq_c_login UNIQUE (c_login);

--------------------------------------------------------------------------------

ALTER TABLE core.pd_users
	ADD CONSTRAINT pd_users_f_level_fkey FOREIGN KEY (f_level) REFERENCES core.pd_levels(id) NOT VALID;
