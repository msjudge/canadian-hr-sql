# Reconstructing onboarding readiness in SQL

Run `python3 verify.py` from the independent project root to rebuild an in-memory database from these CSVs and reconcile every output row. research.sqlite is a generated SQLite database; the CSVs are the corresponding raw synthetic exports. readiness.sql takes a bound `as_of` parameter, normally `2026-09-30`, and returns one row per started hire. Do not substitute string interpolation for the parameter.

## Contract and dictionary

| Table | Grain and key | Meaning |
|---|---|---|
| hire | One hire; hire_id | province, role and random synthetic pilot arm; opened, accepted and start business dates; annual CAD salary |
| task_event | One exported revision; row_id | event_id is a stable hire/task identifier; recorded_date is when the event was known; effective_date is the completion business date; state can reverse to pending |
| calendar | One date; day | is_operating_day is weekday-only for this simulation |
| results.csv | One started hire at the as-of date | ready_date is null when completion evidence is missing; right_censored distinguishes this from a zero-day interval |

`time_to_accept_calendar_days` ends at acceptance, not start or readiness. `observed_unready_workdays` counts dates from start, inclusive, through the day before documented readiness, or through as-of if unresolved. `salary_exposure_cad` multiplies that count by salary/260. It does not measure recoverable waste.

SQL uses CTEs, a deterministic window ordering, conditional aggregation, temporal filtering, a left join that preserves missing evidence and a person-day calendar grain that avoids join fan-out. The latest event revision is selected before evaluating its state. A latest pending revision invalidates an earlier completion.

The input contract permits exactly one logical event_id per hire/task. This is a research export contract, not a generic assumption about Workday/Taleo. Validate it before using any real extract. Timestamps must first be normalized using the source system's time zone and site business calendar. The local simulation contains no actual Workday or Taleo connection.

SQLite makes the project reproducible without a server. It is not MySQL syntax: a MySQL 8 migration would replace date functions with DATEDIFF/DATE_ADD and scalar MAX with GREATEST, and rerun the same edge cases. No MySQL execution is claimed.

Review `docs/report.pdf` in the project root for the inconclusive synthetic intervention result and real-pilot design. The test suite reconciles all generated rows with an independent calculation. For performance work, capture EXPLAIN QUERY PLAN and benchmark on a scaled dataset before making any speed claims; the two indexes here are design choices, not benchmarked improvements.
