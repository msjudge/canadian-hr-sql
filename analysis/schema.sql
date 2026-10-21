PRAGMA foreign_keys = ON;
CREATE TABLE hire (
    hire_id TEXT PRIMARY KEY,
    province TEXT NOT NULL CHECK (province IN ('ON', 'BC')),
    role TEXT NOT NULL,
    arm TEXT NOT NULL CHECK (arm IN ('usual', 'early_handoff')),
    opened_date TEXT NOT NULL,
    accepted_date TEXT NOT NULL,
    start_date TEXT NOT NULL,
    annual_salary_cad INTEGER NOT NULL CHECK (annual_salary_cad > 0),
    CHECK (opened_date <= accepted_date AND accepted_date <= start_date)
);
CREATE TABLE task_event (
    row_id INTEGER PRIMARY KEY,
    event_id TEXT NOT NULL,
    hire_id TEXT NOT NULL REFERENCES hire(hire_id),
    task TEXT NOT NULL CHECK (task IN ('access', 'equipment', 'orientation')),
    effective_date TEXT,
    recorded_date TEXT NOT NULL,
    state TEXT NOT NULL CHECK (state IN ('complete', 'pending'))
);
CREATE INDEX ix_event_asof ON task_event(recorded_date, event_id);
CREATE INDEX ix_event_hire ON task_event(hire_id, task);
CREATE TABLE calendar (
    day TEXT PRIMARY KEY,
    is_operating_day INTEGER NOT NULL CHECK (is_operating_day IN (0, 1))
);
