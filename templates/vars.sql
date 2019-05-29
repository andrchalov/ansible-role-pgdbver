--
-- PGVER variables update script
--

DROP FUNCTION IF EXISTS pgver.vars();

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
{% endif %}
