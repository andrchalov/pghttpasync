
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pghttpasync.job_after_action()
  RETURNS trigger
  LANGUAGE plpgsql
AS $function$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.complete NOTNULL AND OLD.complete ISNULL THEN
      IF NEW.callback NOTNULL THEN
        DECALRE
          e_message text;
        BEGIN
          EXECUTE NEW.callback,
            USING json_build_object(
              'status', NEW.response_status,
              'body', NEW.response_body,
              'response_headers', NEW.response_headers
            );
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
