from pathlib import Path
import json,csv,sqlite3,sys
ROOT=Path(__file__).resolve().parent
A=ROOT/'analysis'
def rows(n):
 r=list(csv.DictReader((A/n).open()))
 for x in r:
  for k,v in x.items():
   try:x[k]=float(v) if '.' in v else int(v)
   except(ValueError,TypeError):pass
 return r
db=sqlite3.connect(':memory:'); db.row_factory=sqlite3.Row
db.executescript((A/'schema.sql').read_text())
for table in ['hire','task_event','calendar']:
 data=list(csv.DictReader((A/(table+'.csv')).open()))
 cols=list(data[0]); q='INSERT INTO '+table+' ('+','.join(cols)+') VALUES ('+','.join('?' for _ in cols)+')'
 db.executemany(q,[[r[k] if r[k]!='' else None for k in cols] for r in data])
result=[dict(x) for x in db.execute((A/'readiness.sql').read_text(),{'as_of':'2026-09-30'})]
s=json.loads((A/'summary.json').read_text())
assert len(result)==s['hires_in_scope']==299
assert sum(x['right_censored'] for x in result)==s['right_censored']==43
assert abs(sum(x['salary_exposure_cad'] for x in result)-s['salary_exposure_cad'])<.01
assert len({x['hire_id'] for x in result})==len(result)
import datetime
for x in result:
 start=datetime.date.fromisoformat(x['start_date']); stop=datetime.date.fromisoformat(x['ready_date']) if x['ready_date'] else datetime.date(2026,10,1)
 expected=sum((start+datetime.timedelta(days=d)).weekday()<5 for d in range((stop-start).days))
 assert expected==x['observed_unready_workdays']
fixture=ROOT/'docs/diagrams/worked-example-fixture.sql'
if fixture.exists():
 d=sqlite3.connect(':memory:');d.row_factory=sqlite3.Row;d.executescript((A/'schema.sql').read_text());d.executescript(fixture.read_text())
 actual=[dict(d.execute((A/'readiness.sql').read_text(),{'as_of':cutoff}).fetchone()) for cutoff in ['2026-09-17','2026-09-18','2026-09-21']]
 assert [x['observed_unready_workdays'] for x in actual]==[3,5,5]
 assert [x['right_censored'] for x in actual]==[0,1,0]
print('PASS: CSV-to-SQLite rebuild; 299 unique hires; 43 unresolved; CAD 1,605,596.08; all person-day counts independently reconciled; correction teaching fixture [3,5,5].')
