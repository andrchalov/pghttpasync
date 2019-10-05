--
-- pghttpreq.job
--

\ir before_action.sql

--------------------------------------------------------------------------------
CREATE TRIGGER before_action
  BEFORE INSERT OR UPDATE
  ON _pghttpreq.job
  FOR EACH ROW
  EXECUTE PROCEDURE pghttpreq.job_before_action();
--------------------------------------------------------------------------------
