--
-- PGVER variables update script
--

DROP FUNCTION IF EXISTS pgver.vars();
DROP FUNCTION IF EXISTS pgver.var(variadic text[]);

{% if pgver_vars %}
-------------------------------------------------------------------------------
CREATE FUNCTION pgver.vars(
{% for key, value in pgver_vars.iteritems() %}
  OUT "{{key}}" text{% if not loop.last %},{% endif %}
{% endfor %}
)
  LANGUAGE sql
AS $function$
SELECT
{% for key, value in pgver_vars.iteritems() %}
  $var${{value}}$var${% if not loop.last %},{% endif %}
{% endfor %}
$function$;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
CREATE FUNCTION pgver.vars_jsonb()
  RETURNS jsonb
  LANGUAGE sql
  IMMUTABLE
AS $function$
SELECT $var${{pgver_vars|tojson|safe}}$var$::jsonb
$function$;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
CREATE FUNCTION pgver.var(VARIADIC text[])
  RETURNS text
  LANGUAGE plpgsql
  IMMUTABLE
AS $function$
DECLARE
  v text;
BEGIN
  v = $var${{pgver_vars|tojson|safe}}$var$::jsonb #>> $1;

  IF v ISNULL THEN
    RAISE 'pgver.var(): Unknown path';
  END IF;

  RETURN v;
END;
$function$;
-------------------------------------------------------------------------------
{% endif %}
