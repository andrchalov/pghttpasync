
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pghttpasync.job_after_action()
  RETURNS trigger
  LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN NEW;
END;
$function$;
-------------------------------------------------------------------------------
