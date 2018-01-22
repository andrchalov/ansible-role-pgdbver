--
-- drop_funcitonal.sql
--
-- Set session to functional for prevent to drop non-functional schemas
--
SET LOCAL SESSION AUTHORIZATION functional;

DO $$
DECLARE
  sch text;
BEGIN
  FOR sch IN SELECT schema_name FROM information_schema.schemata WHERE schema_owner = 'functional'
	LOOP
	  EXECUTE 'DROP SCHEMA IF EXISTS '||quote_ident(sch)||' CASCADE';

		RAISE NOTICE 'SCHEMA "%" DROPED', sch;
	END LOOP;
END;
$$;

--
RESET SESSION AUTHORIZATION;
