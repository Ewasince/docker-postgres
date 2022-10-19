CREATE EXTENSION pg_cron;

SELECT cron.schedule('0 1 * * 5', $$DELETE FROM task WHERE task_create_datetime < now() - interval '12 months'$$);