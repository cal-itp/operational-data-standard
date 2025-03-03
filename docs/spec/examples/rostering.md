# Rostering Examples

A series of examples about how to use TODS to use [roster.txt](/docs/spec.md#rostertxt), [roster_dates.txt](/docs/spec.md#roster_datestxt), [employee_roster.txt](/docs/spec.md#employee_rostertxt), and [employee_run_dates.txt](/docs/spec.md#employee_run_datestxt) to assign employees to roster positions and runs.

TODO this whole file is still being drafted. The list of which examples to include is complete, but no examples are done being drafted.
TODO check that all links work.

## Simple rostering example

(North American scheduling. pick one roster for the whole rating. I don't think there'll be a big difference between roster-style and cafeteria-style in the data?)

## Given an date and trip ID, look up which employee is working on that trip

## Given an date and employee, look up which trips they're doing that day

## Holiday

## Vacation (part of the roster position)

(`roster_dates.txt`: remove old one. assign spare_roster_id (which has no regular assignment) to it on that date. Maybe `spare_roster_id` still needs to be in `rosters.txt` for comprehensive listing reasons, for start/end date, and for (doesn't exist yet) metadata like label)

TODO if it turns out to be identical to Holiday, delete this section and add a note to Holiday that it can be used for vacations too.

## Vacation (not part of the roster position)

In this case, the roster position is not changed on the vacation day, and instead a different employee is assigned to the run on this date using [`employee_run_dates.txt`](/docs/spec.md#employee_run_datestxt)

(`employee_dates`: remove the employee from the roster, add the spare employee.)

## Multi-week roster positions

In this case, each roster position repeats its runs every two weeks, instead of every one week, which is standard at some agencies.

TODO this is common in continental europe, right?

In TODS, this can be represented by having the first and second weeks be two different roster positions, and giving an employee a new roster position assignment each week.

## Rotating assignments

In the UK, it's common for employees to rotate among all roster positions over many weeks. In TODS, this can be represented by assigning each employee to a new roster position each week.

## Minor schedule adjustment

- Scheduled track work one day, times/service_id are slightly changed, but substantially the same.
    - `roster_dates.txt`: `roster_id,date,old_service_id,2;...new_service_id,1`

## Define each roster position day-by-day

No weekly rosters / roster.txt. Just roster_dates.txt.

## No rosters, just `employee_run_dates.txt`

- Producer that doesn't use rosters, just uses `employee_dates` for everything.
