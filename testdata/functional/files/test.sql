
-------------------------------------------------------------------------------
CREATE FUNCTION test_before_action()
  RETURNS trigger
  LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.mo = now();

  RETURN NEW;
END;
$function$;

CREATE TRIGGER test_trigger
  BEFORE INSERT OR UPDATE
  ON test
  FOR EACH ROW
  EXECUTE PROCEDURE test_before_action();
-------------------------------------------------------------------------------
