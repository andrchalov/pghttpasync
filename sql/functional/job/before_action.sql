
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pghttpreq.job_before_action()
  RETURNS trigger
  LANGUAGE plpgsql
AS $function$
BEGIN
  IF TG_OP = 'INSERT' THEN
    PERFORM pg_notify('pghttpreq', NEW.id::text);
  END IF;
  
  RETURN NEW;
END;
$function$;
-------------------------------------------------------------------------------
