-- SQLite 3.25+. Bound parameter :as_of is an inclusive, local business date.
-- effective_date = business occurrence; recorded_date = arrival in the extract.
-- One logical event per hire/task, with revisions and duplicate export rows.
WITH ranked AS (
    SELECT event_id, hire_id, task, effective_date, state,
           ROW_NUMBER() OVER (
               PARTITION BY event_id
               ORDER BY recorded_date DESC, row_id DESC
           ) AS revision_rank
    FROM task_event
    WHERE recorded_date <= :as_of
), pivoted AS (
    SELECT hire_id,
           COUNT(DISTINCT CASE WHEN state = 'complete'
               AND effective_date <= :as_of THEN task END) AS completed_tasks,
           MAX(CASE WHEN state = 'complete' AND effective_date <= :as_of
               THEN effective_date END) AS last_completion
    FROM ranked
    WHERE revision_rank = 1
    GROUP BY hire_id
), readiness AS (
    SELECT h.hire_id, h.province, h.role, h.arm, h.opened_date,
           h.accepted_date, h.start_date, h.annual_salary_cad,
           CASE WHEN p.completed_tasks = 3
               THEN MAX(h.start_date, p.last_completion) END AS ready_date
    FROM hire AS h
    LEFT JOIN pivoted AS p ON p.hire_id = h.hire_id
    WHERE h.start_date <= :as_of
), exposure AS (
    SELECT r.hire_id, r.province, r.role, r.arm, r.opened_date,
           r.accepted_date, r.start_date, r.annual_salary_cad, r.ready_date,
           COUNT(c.day) AS observed_unready_workdays
    FROM readiness AS r
    LEFT JOIN calendar AS c
        ON c.day >= r.start_date
       AND c.day < COALESCE(r.ready_date, DATE(:as_of, '+1 day'))
       AND c.day <= :as_of
       AND c.is_operating_day = 1
    GROUP BY r.hire_id, r.province, r.role, r.arm, r.opened_date,
             r.accepted_date, r.start_date, r.annual_salary_cad, r.ready_date
)
SELECT hire_id, province, role, arm, start_date, ready_date,
       CAST(JULIANDAY(accepted_date) - JULIANDAY(opened_date) AS INTEGER)
           AS time_to_accept_calendar_days,
       observed_unready_workdays,
       CASE WHEN ready_date IS NULL THEN 1 ELSE 0 END AS right_censored,
       ROUND(observed_unready_workdays * annual_salary_cad / 260.0, 2)
           AS salary_exposure_cad
FROM exposure
ORDER BY hire_id;
