--
-- pghttpasync
-- update--001.sql
--

CREATE SCHEMA _pghttpasync AUTHORIZATION :"schema_owner";

--------------------------------------------------------------------------------
CREATE UNLOGGED TABLE _pghttpasync.job (
  id serial NOT NULL,
  mo timestamptz NOT NULL DEFAULT now(),
  method varchar(7) NOT NULL DEFAULT 'GET',
  url text NOT NULL,
  body text,
  args json NOT NULL DEFAULT '{}',
  headers json NOT NULL DEFAULT '{"Content-Type": "application/json"}',
  lifetimesec int NOT NULL DEFAULT 86400,
  priority smallint NOT NULL DEFAULT 1,
  callback text,

  taked timestamptz,
  complete timestamptz,
  failed timestamptz,
  error text,

  response_status smallint,
  response_body text,
  response_headers json,

  CONSTRAINT pghttpasync_pkey PRIMARY KEY (id)
);
ALTER TABLE _pghttpasync.job OWNER TO :"schema_owner";

CREATE INDEX job_idx0 ON _pghttpasync.job (priority, mo)
  WHERE taked ISNULL;
--------------------------------------------------------------------------------
