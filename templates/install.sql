--
-- PGVER install script
--
-- Can be executed multiple times
--

CREATE SCHEMA IF NOT EXISTS pgver;

--------------------------------------------------------------------------------
DO
$BODY$
--
-- Create functional role
--
BEGIN
  IF NOT EXISTS (
    SELECT                       -- SELECT list can stay empty for this
    FROM pg_catalog.pg_roles
    WHERE rolname = 'functional'
  )
  THEN
    CREATE ROLE functional NOSUPERUSER NOLOGIN NOCREATEDB NOCREATEROLE NOREPLICATION INHERIT;
  END IF;
END
$BODY$;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pgver.get_version()
  RETURNS int AS
$BODY$
--
-- Get current database version.
--
SELECT COALESCE(obj_description('pgver'::regnamespace, 'pg_namespace')::int, 0)
$BODY$
  LANGUAGE sql VOLATILE
;

REVOKE EXECUTE ON FUNCTION pgver.get_version() FROM PUBLIC;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pgver.bump_version(current_version_ integer)
  RETURNS text AS
$BODY$
--
-- Update database version (to the next).
--
DECLARE
  db_version_ smallint;
	new_version_ smallint = current_version_ + 1;
BEGIN
  IF (current_version_ ISNULL) THEN
    RAISE 'database version number could not be null';
  END IF;

	db_version_ = pgver.get_version();

  IF (db_version_ IS DISTINCT FROM current_version_) THEN
    RAISE 'database version % is different from %', db_version_, current_version_;
  END IF;

	EXECUTE 'COMMENT ON SCHEMA pgver IS '||quote_literal(new_version_);

  RETURN 'Database successfully updated to version '||new_version_;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
;

REVOKE EXECUTE ON FUNCTION pgver.bump_version(int) FROM PUBLIC;
--------------------------------------------------------------------------------
