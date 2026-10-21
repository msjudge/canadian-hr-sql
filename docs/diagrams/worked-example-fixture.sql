-- SQLite teaching fixture: run after case-01-sql/schema.sql in an EMPTY database.
-- Separate from the 300-hire study sample.
INSERT INTO hire VALUES ('DEMO-01','ON','Analyst','usual','2026-08-01','2026-08-20','2026-09-14',78000);
INSERT INTO task_event VALUES (1, 'access-01', 'DEMO-01', 'access', '2026-09-14', '2026-09-14', 'complete');
INSERT INTO task_event VALUES (2, 'orientation-01', 'DEMO-01', 'orientation', '2026-09-16', '2026-09-16', 'complete');
INSERT INTO task_event VALUES (3, 'equipment-01', 'DEMO-01', 'equipment', NULL, '2026-09-14', 'pending');
INSERT INTO task_event VALUES (4, 'equipment-01', 'DEMO-01', 'equipment', '2026-09-17', '2026-09-17', 'complete');
INSERT INTO task_event VALUES (5, 'equipment-01', 'DEMO-01', 'equipment', NULL, '2026-09-18', 'pending');
INSERT INTO task_event VALUES (6, 'equipment-01', 'DEMO-01', 'equipment', '2026-09-19', '2026-09-21', 'complete');
WITH RECURSIVE dates(day) AS (SELECT '2026-09-01' UNION ALL SELECT date(day,'+1 day') FROM dates WHERE day<'2026-09-30')
INSERT INTO calendar SELECT day, CASE WHEN strftime('%w',day) IN ('0','6') THEN 0 ELSE 1 END FROM dates;
-- Run the unchanged readiness.sql with :as_of = 2026-09-17, 2026-09-18, 2026-09-21.
