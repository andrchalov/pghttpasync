--
-- pghttpasync.job
--

\ir before_action.sql

--------------------------------------------------------------------------------
CREATE TRIGGER before_action
  BEFORE INSERT OR UPDATE
  ON _pghttpasync.job
  FOR EACH ROW
  EXECUTE PROCEDURE pghttpasync.job_before_action();
--------------------------------------------------------------------------------
