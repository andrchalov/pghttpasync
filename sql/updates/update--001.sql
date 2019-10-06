--
-- PGHTTPREQ
-- update--001.sql
--

CREATE SCHEMA _pghttpreq;

--------------------------------------------------------------------------------
CREATE UNLOGGED TABLE _pghttpreq.job (
  id serial NOT NULL,
  mo timestamptz NOT NULL DEFAULT now(),
  method varchar(7) NOT NULL DEFAULT 'GET',
  url text NOT NULL,
  body text,
  args json NOT NULL DEFAULT '',
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

  CONSTRAINT pghttpreq_pkey PRIMARY KEY (id)
);

CREATE INDEX job_idx0 ON _pghttpreq.job (priority, mo)
  WHERE taked ISNULL;
--------------------------------------------------------------------------------
