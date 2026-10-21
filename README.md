# Beyond Time-to-Fill: Onboarding Readiness and HR–IT Handoffs
## The vacancy that survives the hire

**Manvir Singh Judge** · HR Operations · HRIS · People Analytics  
[LinkedIn](https://www.linkedin.com/in/msjudge/) · [GitHub](https://github.com/msjudge)

My experience across recruitment, onboarding and HRIS led me to examine the interval between a hire starting and HR being able to verify operational readiness. I built this independent research project to make that interval visible and test how an earlier HR–IT handoff might be evaluated.

**[Explore the dashboard](https://msjudge.github.io/canadian-hr-sql/)** · [Read the report](docs/report.pdf) · [Follow the visual story](https://msjudge.github.io/canadian-hr-sql/screenshots.html)

All operational records, salaries and programme effects are synthetic. This is an AI-assisted personal research project, not client work or an evaluation of a real employer.

## Research question

Can a snapshot-aware reconstruction of onboarding evidence identify readiness latency without double-counting concurrent blockers—and provide a defensible basis for testing an earlier handoff?

The distinction matters operationally. An accepted offer, a start date and evidence that access, equipment and orientation are complete answer different questions. Late-arriving evidence can also change what HR could have concluded at an earlier reporting date.

## What I implemented

1. **Defined the evidence grain.** One hire record, one exported task-event revision and one operating-calendar date are separate entities. The source contract assumes one logical event per hire/task.
2. **Reconstructed the reporting snapshot.** I filtered events by recorded date before using `ROW_NUMBER()` to select the latest known revision. A later pending state can retract a previous completion.
3. **Derived the readiness gate.** Conditional aggregation requires evidence for all three prerequisites. A `LEFT JOIN` retains hires with missing evidence.
4. **Measured exposure once.** A calendar-range join counts each unready operating date once per hire, even if multiple prerequisites are incomplete.
5. **Interpreted the comparison cautiously.** I compared cohorts using a common first-20-operating-day window and retained the uncertainty interval rather than treating a lower mean as proof of impact.
6. **Built the walkthrough.** The browser dashboard connects filters, query stages, prepared result grids and three diagrams actually created in DrawSQL. The two teaching models are labelled conceptual.

## Results and decision

| September 30, 2026 snapshot | Synthetic result |
|---|---:|
| Started hires | 299 |
| Unverified readiness | 43 (14.4%) |
| Observed unready weekdays | 3,947 |
| Salary exposure proxy | CAD 1,605,596.08 |

The mature-cohort contrast is **0.813 fewer unready days** for early handoff, with an illustrative 95% interval of **−0.559 to 2.046 days**. The interval includes zero. My operational recommendation is to scope a prospective HR–IT handoff pilot with agreed evidence timestamps and a jurisdiction/site-specific operating calendar.

Salary exposure is salary × observed unready weekdays ÷ 260. It is not measured productivity loss, recoverable savings or an employee-performance assessment. The weekday-only calendar does not encode provincial holidays, and current hire attributes are not historically versioned.

## Reproduce the executed analysis

From this folder, using Python 3.12 or later:

```sh
python3 verify.py
```

The verification rebuilds SQLite in memory from the CSVs, reconciles every hire-level result with an independent weekday calculation, checks salary totals and executes a correction fixture with expected person-day results of 3, 5 and 5 at successive cutoffs. No external service or paid account is needed.

Open `docs/index.html` directly or serve it locally:

```sh
python3 -m http.server 8000 --directory docs
```

Use **Focus view** to present a page and **Show navigation** to restore its filters. The browser displays prepared SQLite outputs; it does not run arbitrary SQL or connect to MySQL. The screenshots are of this functional browser replica, not native MySQL Workbench. AI assistance supported implementation and presentation; native vendor proficiency is not inferred from interface resemblance.

## Repository map

- `analysis/`: synthetic source exports, implemented schema, query, generated database and frozen outputs.
- `verify.py`: standalone reconciliation and teaching-fixture check.
- `docs/`: static dashboard, six-page report, screenshot story and downloadable source.
- `docs/diagrams/`: actual DrawSQL captures, import DDL and correction fixture.
- `LINKEDIN.md`: first-person project introduction, project entry and image captions.
- `SOURCES.md`: public research context and implementation references.

## Publishing and provenance

The site uses GitHub Pages from `main` / `docs`. It has no hosted database, paid API or native BI dependency. Public snapshot links may expire; local DrawSQL images and import files are retained.

This project is independently authored under my name and uses only synthetic study data. No resume, private contact details, employer data or third-party portfolio screenshots are included. The limited source review does not establish global novelty. See the report for measurement assumptions, test boundaries and the proposed next study.
