-- CONCEPTUAL METRIC GRAIN. Not tables persisted by the study.
-- Explains the readiness/exposure CTEs at ONE fixed analysis cutoff.
-- PostgreSQL DDL for DrawSQL only; do not migrate the study database.
CREATE TABLE started_hire (
    hire_id TEXT PRIMARY KEY,
    start_date TEXT NOT NULL,
    annual_salary_cad INTEGER NOT NULL
);
CREATE TABLE readiness_gate (
    hire_id TEXT PRIMARY KEY REFERENCES started_hire(hire_id),
    completed_required_tasks INTEGER NOT NULL,
    ready_date TEXT,
    right_censored INTEGER NOT NULL
);
CREATE TABLE operating_calendar (
    day TEXT PRIMARY KEY,
    is_operating_day INTEGER NOT NULL
);
CREATE TABLE unready_person_day (
    hire_id TEXT NOT NULL REFERENCES readiness_gate(hire_id),
    day TEXT NOT NULL REFERENCES operating_calendar(day),
    PRIMARY KEY (hire_id, day)
);
CREATE TABLE hire_exposure (
    hire_id TEXT PRIMARY KEY REFERENCES started_hire(hire_id),
    observed_unready_workdays INTEGER NOT NULL,
    salary_exposure_cad NUMERIC(14,2) NOT NULL
);
-- Include started hires even with zero task rows; missing evidence is unresolved.
-- Ready only after all three required tasks: access, equipment, orientation.
-- Days: start inclusive, ready exclusive; unresolved includes cutoff day.
-- Unique (hire_id, day) prevents concurrent blockers multiplying the count.
-- Zero-day hires have zero person-day rows but still one output row.
-- Exposure = days * annual_salary_cad / 260; not measured loss or savings.
