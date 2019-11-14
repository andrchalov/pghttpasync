
-------------------------------------------------------------------------------
CREATE FUNCTION pghttpasync.worker_job_complete(
  a_id int, a_data json
)
  RETURNS void
  LANGUAGE plpgsql
  SECURITY DEFINER
AS $function$
DECLARE

BEGIN
  UPDATE _pghttpasync.job
    SET complete = now(),
        response_status = (a_data->>'status')::smallint,
        response_body = a_data->>'body',
        response_headers = a_data->'headers'
    WHERE id = a_id
      AND taked NOTNULL
      AND complete ISNULL;
END;
$function$;
-------------------------------------------------------------------------------
