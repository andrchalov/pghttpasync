
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pghttpasync.job_before_action()
  RETURNS trigger
  LANGUAGE plpgsql
AS $function$
BEGIN
  IF TG_OP = 'INSERT' THEN
    PERFORM pg_notify('pghttpasync', NEW.id::text);
  END IF;

  IF TG_OP = 'UPDATE' THEN
    IF NEW.complete NOTNULL AND OLD.complete ISNULL THEN
      IF NEW.callback NOTNULL THEN
        DECLARE
          e_message text;
        BEGIN
          EXECUTE NEW.callback
            USING NEW.response_status, NEW.response_body, NEW.response_headers;
        EXCEPTION WHEN OTHERS THEN
          GET STACKED DIAGNOSTICS NEW.error = MESSAGE_TEXT;
          NEW.error = 'Callback failed: '||NEW.error;
        END;
      END IF;
    END IF;
  END IF;

  RETURN NEW;
END;
$function$;
-------------------------------------------------------------------------------
