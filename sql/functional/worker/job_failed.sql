
-------------------------------------------------------------------------------
CREATE FUNCTION pghttpreq.worker_job_failed(a_id int, a_error text)
  RETURNS void
  LANGUAGE plpgsql
  SECURITY DEFINER
AS $function$
DECLARE

BEGIN
  UPDATE _pghttpreq.job
    SET error = a_error,
        failed = now()
    WHERE id = a_id
      AND taked NOTNULL
      AND complete ISNULL;
END;
$function$;
-------------------------------------------------------------------------------
