-- CONCEPTUAL AUDIT MODEL. Not tables persisted by the study.
-- Makes the ranked CTE's two clocks and chosen revision inspectable.
-- PostgreSQL DDL for DrawSQL only; do not migrate the study database.
CREATE TABLE audit_cutoff (
    as_of_date TEXT PRIMARY KEY
);
CREATE TABLE logical_task (
    event_id TEXT PRIMARY KEY,
    hire_id TEXT NOT NULL,
    task TEXT NOT NULL
);
CREATE TABLE event_revision (
    row_id INTEGER PRIMARY KEY,
    event_id TEXT NOT NULL REFERENCES logical_task(event_id),
    effective_date TEXT,
    recorded_date TEXT NOT NULL,
    state TEXT NOT NULL
);
CREATE TABLE selected_evidence (
    as_of_date TEXT NOT NULL REFERENCES audit_cutoff(as_of_date),
    event_id TEXT NOT NULL REFERENCES logical_task(event_id),
    selected_row_id INTEGER NOT NULL REFERENCES event_revision(row_id),
    PRIMARY KEY (as_of_date, event_id)
);
-- Selection: recorded_date <= cutoff; order recorded_date DESC, row_id DESC.
-- One event_id per hire/task is an INPUT ASSUMPTION in the actual study.
-- This proposed model exposes it; no logical_task table exists in SQLite.
-- A selected 'pending' revision can retract an earlier 'complete' revision.
