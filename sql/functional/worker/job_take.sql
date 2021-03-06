
-------------------------------------------------------------------------------
CREATE FUNCTION pghttpasync.worker_job_take()
  RETURNS TABLE (
    id int, method varchar(7), url text, body text, args json, headers json
  )
  LANGUAGE plpgsql
  SECURITY DEFINER
AS $function$
DECLARE
  v_id int;
BEGIN
  SELECT j.id INTO v_id
    FROM _pghttpasync.job j
    WHERE j.taked ISNULL
    ORDER BY j.priority, j.id
    FOR UPDATE
    LIMIT 1;
  --
  IF found THEN
    RETURN QUERY
      UPDATE _pghttpasync.job j
        SET taked = now()
        WHERE j.id = v_id
        RETURNING j.id, j.method, j.url, j.body, j.args, j.headers;
  END IF;
END;
$function$;
-------------------------------------------------------------------------------
