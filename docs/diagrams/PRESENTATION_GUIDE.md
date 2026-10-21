# A hire is not the same as readiness

Three diagrams created in the DrawSQL playground for **The vacancy that survives the hire**, an independent synthetic Canadian HR study.

## Present in this order

### 1. The vacancy that survives the hire — implemented source model

**Opening line:** “A requisition can close while the evidence needed to call the new hire ready is still missing.”

Show `hire` first. Its grain is one hire. Follow the single foreign key to `task_event`: each row is an exported revision, not a different person or a different day. A hire may have zero event rows; each event belongs to exactly one hire. The calendar is intentionally disconnected in the ERD: the query joins it using a date interval, not a foreign key.

**Technical evidence:** 3 tables, 17 columns, 1 foreign key; two task-event indexes.

**Honest boundary:** The actual runtime is SQLite. The import removes only SQLite's `PRAGMA` directive and uses PostgreSQL as DrawSQL's display driver. DrawSQL converts CHECK-domain fields to visible enum labels; the actual source uses TEXT and INTEGER. SQL source is authoritative. Province is ON/BC; the prototype calendar is weekdays only, not a complete provincial holiday calendar.

### 2. What did we know then? — conceptual audit model

**Opening line:** “A completion date and the date HR received evidence of that completion answer different questions.”

Walk from `logical_task` through `event_revision` to `selected_evidence`. `audit_cutoff` determines which revisions could have been known. First exclude revisions recorded after the cutoff. Then choose the latest recorded date per event, breaking same-day ties with the row ID.

**Technical evidence:** This explains `ranked` in `readiness.sql`, including the order of filtering and window ranking. A selected pending revision can retract an earlier complete revision.

**Honest boundary:** These 4 tables are an explanatory decomposition, not additional tables in the running database. The logical event mapping is an assumed input contract in the current study. This is not a production bitemporal warehouse: historical hire attributes are not reconstructed, dates have day-level resolution, and the illustrative audit schema would need further consistency constraints before production use.

### 3. Three blockers, one person-day — conceptual metric grain

**Opening line:** “Access, equipment and orientation can all be late on the same Monday. That is one exposed person-day.”

Start at `started_hire`. `readiness_gate` stays unresolved until all three required tasks have qualifying completion evidence. `unready_person_day` makes the unit explicit: one `(hire_id, day)` pair. A zero-delay hire contributes no such pairs but still belongs in `hire_exposure` with zero days.

**Technical evidence:** This explains `pivoted`, `readiness` and `exposure`. The real query counts unique calendar rows inside one interval; it does not materialize the person-day table.

**Honest boundary:** Conceptual schema at one fixed cutoff. Foreign-key connectors express proposed entity associations, not execution arrows. The current query outputs one row for every started hire, including missing-evidence cases. Salary / 260 is an exposure proxy, not observed productivity loss, recoverable money or demonstrated savings.

## A 90-second worked example

Separate synthetic teaching fixture **DEMO-01**, not an observation from the 300-hire research sample. Start Monday 14 September 2026, salary CAD 78,000; daily proxy CAD 300.

1. Access completes 14 September; orientation completes 16 September.
2. Equipment is reported complete on 17 September, effective that day.
3. On 18 September that equipment event is revised to pending.
4. On 21 September the same event is corrected to complete, effective Saturday 19 September.

| Cutoff | Selected equipment evidence | Ready date | Unready weekdays | Censored | Exposure |
|---|---|---|---:|---:|---:|
| 17 Sep | complete, recorded 17 Sep | 17 Sep | 3 | 0 | CAD 900 |
| 18 Sep | pending, recorded 18 Sep | unknown | 5 | 1 | CAD 1,500 |
| 21 Sep | complete, recorded 21 Sep | 19 Sep | 5 | 0 | CAD 1,500 |

These values were obtained by executing the unchanged study query against the teaching fixture. Readiness is excluded from the counted interval; an unresolved cutoff is included. The Saturday completion adds no operating day. At 17 September, adding individual task waits (0 + 2 + 3) gives 5, but the union is only 3 person-days.

The 18 September answer must not use the correction that arrives on 21 September. That is the central point of the second diagram.

## Present the business conclusion carefully

“The design exposes a measurement gap and supports a controlled handoff pilot. It does not establish real employer savings. The synthetic mature-cohort interval includes zero, and the generator imposes a treatment effect.”

## Reuse without paying

- Use the linked DrawSQL snapshots to explore the diagrams. They contain synthetic schema and annotations only.
- PNGs are browser captures of the actual DrawSQL canvases, not native image exports.
- The adjacent `.sql` files can be pasted into DrawSQL → File → Import with PostgreSQL selected. Importing replaces the current playground canvas; preserve an existing diagram first.
- Use the gallery as the SQL case-study companion on GitHub Pages. The static images remain available in the repository independently of DrawSQL.
- The DrawSQL share dialog called links permanent, but its documentation says playground shared links expire after 30 days of inactivity. Treat them as convenience links, not the only archive.
- Native export prompted for an account during this run. No account was created, no paid plan was selected, and no résumé or employee records were uploaded.

## Source and verification

- Implemented: `case-01-sql/schema.sql` and `case-01-sql/readiness.sql`.
- Verified DrawSQL imports: 3/17/1, 4/12/4 and 5/14/4 respectively (tables/columns/relationships; final figure verified in the UI).
- [DrawSQL playground documentation](https://drawsql.app/docs/draw-overview)
- [DrawSQL import documentation](https://drawsql.app/docs/import-your-schema)
- [DrawSQL JSON export documentation](https://drawsql.app/docs/export-and-import-json)
- Checked 20 October 2026.
