# Beyond Time-to-Fill: Onboarding Readiness and HR–IT Handoffs — LinkedIn launch kit

Publishing note: GitHub and the live dashboard are published. The study is listed in LinkedIn Projects and Featured. Feed copy below is a draft; check the publication record before scheduling or posting.

## Final first-person post

A closed requisition does not necessarily mean a ready employee.

My work across recruitment, onboarding and HRIS has made me interested in what happens between those two milestones: access provisioning, equipment availability, orientation and the handoffs between HR, IT and hiring managers.

For my first independent Canadian HR research study, I developed “Beyond Time-to-Fill: Onboarding Readiness and HR–IT Handoffs” to examine that gap using synthetic Ontario/B.C. records.

My question was: when could HR actually verify readiness—and would an earlier handoff justify an operational pilot?

I used SQL to reconstruct the evidence available at each reporting cutoff, select the latest task revisions and retain hires whose readiness remained unresolved. I then counted overlapping prerequisite waits once per person-day, rather than adding them together.

At the September cutoff:
• 299 hires had started.
• 43 had unverified readiness (14.4%).
• The model recorded 3,947 unready weekdays.

The early-handoff cohort averaged 0.813 fewer unready days over a common 20-operating-day window. But the illustrative 95% interval crossed zero (−0.559 to 2.046 days). I would use that result to design a prospective HR–IT pilot, not to claim that the intervention worked.

The visual walkthrough follows the work end to end: source schema → revision-aware SQL → result grid → management dashboard → research interpretation. Three diagrams created in DrawSQL explain the implemented schema, the evidence-arrival clock and the count-once rule.

All study records and cost assumptions are synthetic. I developed the project with AI assistance; SQLite was executed and reconciled against an independent weekday calculation. The Workbench-style interface is a browser replica. Salary exposure is a planning proxy, not a measured business loss.

Dashboard, research report and reproducible source:
https://msjudge.github.io/canadian-hr-sql/

Manvir Singh Judge | HR Operations · HRIS · People Analytics

#PeopleAnalytics #HRIS #SQL #Onboarding #CanadianHR

## Project entry

**Title:** Beyond Time-to-Fill: Onboarding Readiness and HR–IT Handoffs

**Author:** Manvir Singh Judge

**Association:** Independent research / personal project; no employer association.

**Description:** I developed a synthetic Ontario/B.C. onboarding study to distinguish recruitment closure from verifiable operational readiness. I reconstructed task revisions with SQL window functions, preserved unresolved hires and counted overlapping waits once per person-day. I reconciled 299 hire-level outputs against an independent calendar calculation and created three DrawSQL diagrams to explain the evidence model. The early-handoff contrast remains inconclusive; my recommendation is a prospective HR–IT pilot. SQLite was executed. The Workbench-style interface is an independently built browser replica, developed with AI assistance.

**Skills:** SQL · HRIS data quality · Data modelling · Onboarding operations · People analytics

**Dashboard URL:** https://msjudge.github.io/canadian-hr-sql/

**Repository:** https://github.com/msjudge/canadian-hr-sql

**Profile:** https://www.linkedin.com/in/msjudge/

## Screenshot sequence and captions

### 01 / Recruitment closure versus operational readiness

File: `docs/screenshots/01-overview.png`

The management view separates started hires, unresolved evidence, unique person-days and a salary-based exposure proxy. The fixed mature-cohort comparison uses a common 20-operating-day window. Its interval crosses zero; the correct recommendation is to test the handoff prospectively.

### 02 / Reconstruct the evidence before aggregating it

File: `docs/screenshots/02-workbench.png`

The latest-revision stage ranks each logical event by recorded date and export-row tie-breaker. The displayed 878 task-event records are a different grain from the 299-hire result. The result grid is prepared from executed SQLite analysis; no MySQL server is connected.

### 03 / The implemented data contract

File: `docs/diagrams/01-implemented-schema.png`

Actual DrawSQL capture: hire, task_event and calendar. The hire-to-event relationship preserves revision history; the calendar supplies the operating-day denominator. The PostgreSQL import adapter is a visual representation of the implemented SQLite schema.

### 04 / Two clocks, two different questions

File: `docs/diagrams/02-evidence-clock.png`

Conceptual teaching model created in DrawSQL. Effective date describes the business event; recorded date determines what the analyst could have known. These teaching entities explain the query and are not extra production tables.

### 05 / Count exposure once

File: `docs/diagrams/03-count-once.png`

Conceptual DrawSQL model of the readiness gate and unique hire-day exposure. Overlapping prerequisite waits must not be added as if they were separate people. The DEMO-01 fixture reproduces 3, 5 and 5 person-days as the evidence cutoff changes.

## Posting sequence

Use this project as its own post and project entry. Attach the overview first, then the technical evidence; keep the caption text adjacent to each image where the interface allows it. Add the verified live dashboard to Featured as a separate work sample. The report can be attached as a document when you want a longer methods walkthrough. Review the draft in your own voice before posting.
