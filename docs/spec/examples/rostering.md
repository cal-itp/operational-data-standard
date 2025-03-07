# Rostering Examples

A series of examples about how to use TODS to use [roster.txt](/docs/spec.md#rostertxt), [roster_dates.txt](/docs/spec.md#roster_datestxt), [employee_roster.txt](/docs/spec.md#employee_rostertxt), and [employee_run_dates.txt](/docs/spec.md#employee_run_datestxt) to assign employees to roster positions and runs.

TODO this whole file is still being drafted. The list of which examples to include is complete, but no examples are done being drafted.
TODO check that all links work.

## Simplest example: employee_run_dates.txt only.

The simplest way to assign employees to runs is to use `employee_run_dates.txt`. This will require one row per employee per date.

In this example, `A` and `B` work Saturday Feb 1 and Wednesday Feb 5 through Friday Feb 7. `C` and `D` work Sunday Feb 2 through Tuesday Feb 4.

**`calendar.txt`**

```
service_id,monday,tuesday,wednesday,thursday,friday,saturday,start_date,end_date
weekend,0,0,0,0,0,1,1,20250201,20250207
weekday,1,1,1,1,1,0,0,20250201,20250207
```

February 1, 2025 was a Saturday.

**`run_events.txt`**

For this example, the purpose of this file is just to show which runs exist. Real runs would have more interesting data.

```
service_id,run_id,event_sequence,event_type,start_location,start_time,end_location,end_time
weekend,101,1,work,station,09:00:00,station,17:00:00
weekend,102,1,work,station,09:00:00,station,17:00:00
weekday,103,1,work,station,09:00:00,station,17:00:00
weekday,104,1,work,station,09:00:00,station,17:00:00
```

**`employee_run_dates.txt`**

```
date,service_id,run_id,employee_id
20250201,weekend,101,A
20250201,weekend,102,B
20250202,weekend,101,C
20250202,weekend,102,D
20250203,weekday,103,C
20250203,weekday,104,D
20250204,weekday,103,C
20250204,weekday,104,D
20250205,weekday,103,A
20250205,weekday,104,B
20250206,weekday,103,A
20250206,weekday,104,B
20250207,weekday,103,A
20250207,weekday,104,B
```

## Example with Rosters

This example represents the same schedule as above, but groups multiple days of work into roster positions that employees are assigned to all at once. `A` and `B` work Saturdays, Wednesdays, Thursdays, and Fridays. `C` and `D` work Sundays, Mondays, and Tuesdays.

`calendar.txt` and `run_events.txt` are the same as the previous example.

This example does not have any exceptions to the regular schedule, so doesn't need `roster_dates.txt` or `employee_run_dates.txt`.

**`roster_positions.txt`**

```
roster_position_id,start_date,end_date,monday_service_id,monday_run_id,tuesday_service_id,tuesday_run_id,wednesday_service_id,wednesday_run_id,thursday_service_id,thursday_run_id,friday_service_id,friday_run_id,saturday_service_id,saturday_run_id,sunday_service_id,sunday_run_id
wed_to_sat_1,20250201,20250207,,,,,weekday,103,weekday,103,weekday,103,weekend,101,,
wed_to_sat_2,20250201,20250207,,,,,weekday,104,weekday,104,weekday,104,weekend,102,,
sun_to_tue_1,20250201,20250207,weekday,103,weekday,103,,,,,,,,,weekend,101
sun_to_tue_2,20250201,20250207,weekday,104,weekday,104,,,,,,,,,weekend,102
```

**`employee_roster.txt`**

```
roster_position_id,start_date,end_date,employee_id
wed_to_sat_1,20250201,20250207,A
wed_to_sat_2,20250201,20250207,B
sun_to_tue_1,20250201,20250207,C
sun_to_tue_2,20250201,20250207,D
```

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
