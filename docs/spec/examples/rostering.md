# Rostering Examples

A series of examples about how to use [roster.txt](/docs/spec.md#rostertxt), [roster_dates.txt](/docs/spec.md#roster_datestxt), [employee_roster.txt](/docs/spec.md#employee_rostertxt), and [employee_run_dates.txt](/docs/spec.md#employee_run_datestxt) to assign employees to roster positions and runs.

TODO check column ordering

## Simplest example: employee_run_dates.txt only.

The simplest way to assign employees to runs is to use [`employee_run_dates.txt`](/docs/spec.md#employee_run_datestxt). This will require one row per employee per date.

In this example, `A` and `B` work Saturday Feb 1 and Wednesday Feb 5 through Friday Feb 7. `C` and `D` work Sunday Feb 2 through Tuesday Feb 4.

**[`calendar.txt`](https://gtfs.org/documentation/schedule/reference/#calendartxt)**

```
service_id,monday,tuesday,wednesday,thursday,friday,saturday,start_date,end_date
weekend,0,0,0,0,0,1,1,20250201,20250207
weekday,1,1,1,1,1,0,0,20250201,20250207
```

February 1, 2025 was a Saturday.

**[`run_events.txt`](/docs/spec.md#run_eventstxt)**

For this example, the purpose of this file is just to show which runs exist. Real runs would have more interesting data.

```
service_id,run_id,event_sequence,event_type,start_location,start_time,end_location,end_time
weekend,101,1,work,station,09:00:00,station,17:00:00
weekend,102,1,work,station,09:00:00,station,17:00:00
weekday,103,1,work,station,09:00:00,station,17:00:00
weekday,104,1,work,station,09:00:00,station,17:00:00
```

**[`employee_run_dates.txt`](/docs/spec.md#employee_run_datestxt)**

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

This example represents the same schedule of runs as above, but groups multiple days of work into roster positions that employees are assigned to all at once. Roster positions `A` and `B` work Saturdays, Wednesdays, Thursdays, and Fridays. Positions `C` and `D` work Sundays, Mondays, and Tuesdays.

[`calendar.txt`](https://gtfs.org/documentation/schedule/reference/#calendartxt) and [`run_events.txt`](/docs/spec.md#run_eventstxt) are the same as the previous example.

This example does not have any exceptions to the regular schedule, so doesn't need [`roster_dates.txt`](/docs/spec.md#roster_datestxt) or [`employee_run_dates.txt`](/docs/spec.md#employee_run_datestxt).

**[`roster_positions.txt`](/docs/spec.md#roster_positionstxt)**

```
roster_position_id,start_date,end_date,monday_service_id,monday_run_id,tuesday_service_id,tuesday_run_id,wednesday_service_id,wednesday_run_id,thursday_service_id,thursday_run_id,friday_service_id,friday_run_id,saturday_service_id,saturday_run_id,sunday_service_id,sunday_run_id
wed_to_sat_1,20250201,20250207,,,,,weekday,103,weekday,103,weekday,103,weekend,101,,
wed_to_sat_2,20250201,20250207,,,,,weekday,104,weekday,104,weekday,104,weekend,102,,
sun_to_tue_1,20250201,20250207,weekday,103,weekday,103,,,,,,,,,weekend,101
sun_to_tue_2,20250201,20250207,weekday,104,weekday,104,,,,,,,,,weekend,102
```

**[`employee_roster.txt`](/docs/spec.md#employee_rostertxt)**

```
roster_position_id,start_date,end_date,employee_id
wed_to_sat_1,20250201,20250207,A
wed_to_sat_2,20250201,20250207,B
sun_to_tue_1,20250201,20250207,C
sun_to_tue_2,20250201,20250207,D
```

## Example algorithm for looking up data

Here are example algorithms (written in pseudocode) for a couple typical lookups a consumer might do in the roster files. These examples show how to connect data across all the roster files.

This algorithm will cover edge cases and work for both simple and complex cases. If you know you have simpler data, you may be able to use simpler rules.

### Given a date and trip ID, look up which employees are working on that trip

```
# Returns a list of employee IDs
def employees_on_trip(service_date, trip_id):
    # List of (service_id, run_id). There may be 0 (run_events.txt is incomplete), 1, or many (if multiple people work on that trip).
    runs_on_trip =
        SELECT DISTINCT (service_id, run_id) FROM run_events.txt
        WHERE run_events.trip_id = ${trip_id}

    employees_on_trip = []
    for each (service_id, run_id) in runs_on_trip:
        roster_positions_on_run = roster_positions_on_run(service_id, run_id, service_date)
        employees_on_run = employees_on_run(service_id, run_id, roster_positions_on_run, service_date)
        employees_on_trip.add(employees_on_run)

    return employees_on_trip

# Returns a list of roster position IDs
# There could be 0 (if the data is incomplete), 1 (the normal situation), or many (shouldn't happen but isn't prohibited by the spec)
def roster_positions_on_run(service_id, run_id, service_date):
    day_of_week = day_of_week_for_date(service_date)
    result = []
    # start with roster positions that do this run on a regular week
    result.add(
        SELECT roster_position_id FROM roster_positions.txt
        WHERE start_date <= ${service_date}
        AND end_date >= ${service_date}
        AND ${day_of_week}_run_id = ${run_id}
        AND ("${day_of_week}_service_id" IS NULL OR "${day_of_week}_service_id" = ${service_id})
    )
    # remove roster positions with exception_type=2 in roster_dates.txt
    result.remove(
        SELECT roster_position_id FROM roster_dates.txt
        WHERE date = ${service_date}
        AND exception_type = 2
        AND roster_position_id = ${roster_position_id}
    )
    # add roster positions with exception_type=1 in roster_dates.txt
    result.remove(
        SELECT roster_position_id FROM roster_dates.txt
        WHERE date = ${service_date}
        AND (exception_type IS NULL OR exception_type = 1)
        AND roster_position_id = ${roster_position_id}
    )
    return result

# Returns a list of employee IDs
# There could be 0 (if the work is unassigned), 1 (the normal situation), or many (shouldn't happen but isn't prohibited by the spec)
def employees_on_run(service_id, run_id, roster_positions_on_run, service_date):
    result = []
    # start with the employees assigned to the run via the roster
    result.add(
        SELECT employee_id FROM employee_roster.txt
        WHERE employee_roster.roster_position_id in ${roster_positions_on_run}
        AND employee_roster.start_date <= ${service_date}
        AND employee_roster.end_date >= ${service_date}
    )
    # remove any employees with exception_type=2
    result.remove(
        SELECT employee_id FROM employee_run_dates.txt
        WHERE employee_run_dates.date = ${service_date}
        AND employee_run_dates.exception_type = 2
        AND employee_run_dates.employee_id in ${employees_on_run}
    )
    # add any employees with exception_type=1 for this run
    result.add(
        SELECT employee_id FROM employee_run_dates.txt
        WHERE date = ${service_date}
        AND (exception_type IS NULL OR exception_type = 1)
        AND run_id = ${run_id}
        AND (service_id IS NULL OR service_id = ${service_id})
    )
    return result
```

### Given an date and employee ID, look up which trips they're working on that day

```
# Returns a list of trip IDs
def trips_for_employee(employee_id, service_date):
    # List of roster postions that the employee is doing on this date
    # There could be 0 (if the employee doesn't have regular work, such as someone on a spare list)
    # or 1 (a normal situation),
    # or many (if an employee is assigned to multiple roster positions, which would be unusual but is allowed by the spec)
    roster_position_ids =
        SELECT roster_position_id FROM employee_roster.txt
        WHERE employee_id = ${employee_id}
        AND start_date <= ${service_date}
        AND end_date >= ${service_date}

    # List of (service_id, run_id) pairs, or (NULL, run_id) if the data omits the service id
    runs = []
    # first get runs that come from roster position assignments
    for roster_position_id in roster_position_ids:
        runs.add(runs_for_roster_position(roster_position_id, service_date))
    # then remove any runs removed by employee_run_dates.txt
    runs.remove(
        SELECT (service_id, run_id) FROM employee_run_dates.txt
        WHERE date = ${service_date}
        AND exception_type = 2
        AND employee_id = ${employee_id}
    )
    # then add any runs added by employee_run_dates.txt
    runs.add(
        SELECT (service_id, run_id) FROM employee_run_dates.txt
        WHERE date = ${service_date}
        AND exception_type = 1
        AND employee_id = ${employee_id}
    )

    # Now we know which runs the employee is working on this date. Look up the trips on those runs in run_events.txt
    trip_ids = []
    # note service_id might be NULL here
    for (service_id, run_id) in runs:
        trip_ids.add(trips_for_run(service_id, run_id, service_date))
    return trip_ids

# returns List of (service_id, run_id) pairs
# service_id could be NULL if the data omits it
# There could be 0 results if the roster position is not working that day
# 1 result if it is
# or many if the roster position is working multiple runs, which would not be common but is allowed by the roster_dates.txt spec.
def runs_for_roster_position(roster_position_id, service_date):
    day_of_week = day_of_week_for_date(service_date)
    result = []
    # start with runs from the roster assignment, at most one result
    result.add(
        SELECT ("${day_of_week}_service_id", "${day_of_week}_run_id")
        FROM roster_positions.txt
        WHERE roster_position_id = ${roster_position_id}
        AND start_date <= ${service_date}
        AND end_date >= ${service_date}
    )
    # if the roster position has exception_type=2 in run_dates.txt, then ignore the run from roster_positions.txt
    if (
        SELECT (service_id, run_id)
        FROM roster_dates.txt
        WHERE roster_position_id = ${roster_position_id}
        AND date = ${service_date}
        AND exception_type = 2
    ):
      result = []
    # add any runs with exception_type=1 in run_dates.txt
    result.add(
        SELECT (service_id, run_id)
        FROM roster_dates.txt
        WHERE roster_position_id = ${roster_position_id}
        AND date = ${service_date}
        AND exception_type = 1
    )
    return result

# input service_id might be NULL
# Returns list of trip IDs
def trips_for_run(service_id, run_id, service_date):
    # If the roster data omits service_ids, allow matching to a run on any service_id that's active on this date
    # Look up which services are active from the GTFS calendar (after applying any TODS supplement files), based on the service_date and day_of_week.
    # In real code you'd probably want to calculate this once for all queries
    active_services = ...

    if service_id == NULL:
        SELECT trip_id FROM run_events.txt
        WHERE run_id = ${run_id}
        AND service_id in ${active_services}
    else:
        SELECT trip_id FROM run_events.txt
        WHERE run_id = ${run_id}
        AND service_id = ${service_id}
```

## Holiday

In this example, the roster includes holidays, which are defined as exceptions in [`roster_dates.txt`](/docs/spec.md#roster_datestxt).

This agency has two workers, who work M-F. There's no service on weekends. On each holiday, the agency runs half the service, and each worker gets one holiday off.

The holidays are built into the roster positions, so there's no need for [`employee_run_dates.txt`](/docs/spec.md#employee_run_datestxt).

**[`calendar.txt`](https://gtfs.org/documentation/schedule/reference/#calendartxt)**

```
service_id,monday,tuesday,wednesday,thursday,friday,saturday,start_date,end_date
weekday,1,1,1,1,1,0,0,20240701,20240714
```

July 1, 2024 was a Monday.

**[`calendar_dates.txt`](https://gtfs.org/documentation/schedule/reference/#calendar_datestxt)**

```
service_id,date,exception_type
weekday,20240702,2
holiday,20240702,1
weekday,20240711,2
holiday,20240711,1
```

Holidays are Tuesday, July 2, and Thursday, July 11.

**[`run_events.txt`](/docs/spec.md#run_eventstxt)**

For this example, the purpose of this file is just to show which runs exist. Real runs would have more interesting data.

```
service_id,run_id,event_sequence,event_type,start_location,start_time,end_location,end_time
weekday,101,1,work,station,09:00:00,station,17:00:00
weekday,102,1,work,station,09:00:00,station,17:00:00
holiday,999,1,work,station,09:00:00,station,17:00:00
```

**[`roster_positions.txt`](/docs/spec.md#roster_positionstxt)**

```
roster_position_id,start_date,end_date,monday_service_id,monday_run_id,tuesday_service_id,tuesday_run_id,wednesday_service_id,wednesday_run_id,thursday_service_id,thursday_run_id,friday_service_id,friday_run_id,saturday_service_id,saturday_run_id,sunday_service_id,sunday_run_id
POSITION-A,20240701,20240714,weekday,101,weekday,101,weekday,101,weekday,101,weekday,101,,,,
POSITION-B,20240701,20240714,weekday,102,weekday,102,weekday,102,weekday,102,weekday,102,,,,
```

**[`roster_dates.txt`](/docs/spec.md#roster_datestxt)**

```
roster_position_id,date,exception_type,service_id,run_id
POSITION-A,20240702,2,,
POSITION-B,20240702,2,,
POSITION-A,20240702,1,holiday,999
POSITION-A,20240711,2,,
POSITION-B,20240711,2,,
POSITION-B,20240711,1,holiday,999
```

**[`employee_roster.txt`](/docs/spec.md#employee_rostertxt)**

```
roster_position_id,start_date,end_date,employee_id
POSITION-A,20240701,20240714,EMPLOYEE-A
POSITION-B,20240701,20240714,EMPLOYEE-B
```

## Vacation (part of the roster position)

In this example, this agency runs service 4 days a week, with two employees who each regularly work two days per week. When each employee goes on vacation, their work is covered by a third employee on a third roster position.

These vacations are built in to the roster.

The third employee has no regular work, so appears in [`roster_dates.txt`](/docs/spec.md#roster_datestxt) but not [`roster_positions.txt`](/docs/spec.md#roster_positionstxt).

**[`calendar.txt`](https://gtfs.org/documentation/schedule/reference/#calendartxt)**

```
service_id,monday,tuesday,wednesday,thursday,friday,saturday,start_date,end_date
weekday,1,1,0,1,1,0,0,20240701,20240721
```

July 1, 2024 was a Monday.

**[`run_events.txt`](/docs/spec.md#run_eventstxt)**

In this simple example, there's only one employee working per day, and they only do one run_event per day.

```
service_id,run_id,event_sequence,event_type,start_location,start_time,end_location,end_time
weekday,100,1,work,station,09:00:00,station,17:00:00
```

**[`roster_positions.txt`](/docs/spec.md#roster_positionstxt)**

One works Monday and Tuesady, the other works Thursday and Friday.

```
roster_position_id,start_date,end_date,monday_service_id,monday_run_id,tuesday_service_id,tuesday_run_id,wednesday_service_id,wednesday_run_id,thursday_service_id,thursday_run_id,friday_service_id,friday_run_id,saturday_service_id,saturday_run_id,sunday_service_id,sunday_run_id
POSITION-A,20240701,20240721,weekday,100,weekday,100,,,,,,,,,,
POSITION-B,20240701,20240721,,,,,,,weekday,100,weekday,100,,,,
```

**[`roster_dates.txt`](/docs/spec.md#roster_datestxt)**

When each roster position goes on vacation for two days, the third subsitute roster position fills in.

```
roster_position_id,date,exception_type,service_id,run_id
POSITION-A,20240708,2,,
POSITION-C,20240708,1,weekday,100
POSITION-A,20240709,2,,
POSITION-C,20240709,1,weekday,100
POSITION-B,20240718,2,,
POSITION-C,20240718,1,weekday,100
POSITION-B,20240719,2,,
POSITION-C,20240719,1,weekday,100
```

**[`employee_roster.txt`](/docs/spec.md#employee_rostertxt)**

```
roster_position_id,start_date,end_date,employee_id
POSITION-A,20240701,20240721,EMPLOYEE-A
POSITION-B,20240701,20240721,EMPLOYEE-B
POSITION-C,20240701,20240721,EMPLOYEE-C
```

The vacations are built into the roster positions, so the employees stay assigned to the roster position the whole time. There's no need for [`employee_run_dates.txt`](/docs/spec.md#employee_run_datestxt).


## Vacation (not part of the roster position)

In this case, the same employees work on the same days as in the previous example. But this time the roster position continue their regular assignments on the vacation day, and the employees get their vacations by being unassigned from their roster position in [`employee_run_dates.txt`](/docs/spec.md#employee_run_datestxt).

[`calendar.txt`](https://gtfs.org/documentation/schedule/reference/#calendartxt) and [`run_events.txt`](/docs/spec.md#run_eventstxt) are the same as above.

**[`roster_positions.txt`](/docs/spec.md#roster_positionstxt)**

[`roster_positions.txt`](/docs/spec.md#roster_positionstxt) is the same as in the previous example, because the regular week is the same.

One works Monday and Tuesady, the other works Thursday and Friday.

```
roster_position_id,start_date,end_date,monday_service_id,monday_run_id,tuesday_service_id,tuesday_run_id,wednesday_service_id,wednesday_run_id,thursday_service_id,thursday_run_id,friday_service_id,friday_run_id,saturday_service_id,saturday_run_id,sunday_service_id,sunday_run_id
POSITION-A,20240701,20240721,weekday,100,weekday,100,,,,,,,,,,
POSITION-B,20240701,20240721,,,,,,,weekday,100,weekday,100,,,,
```

In this example, there is no [`roster_dates.txt`](/docs/spec.md#roster_datestxt) file, because the roster positions continue reguarly. There is no 3rd roster position.

**[`employee_roster.txt`](/docs/spec.md#employee_rostertxt)**

```
roster_position_id,start_date,end_date,employee_id
POSITION-A,20240701,20240721,EMPLOYEE-A
POSITION-B,20240701,20240721,EMPLOYEE-B
```

`EMPLOYEE-C` has no roster position that they are regularly assigned to.

**[`employee_run_dates.txt`](/docs/spec.md#employee_run_datestxt)**

POSITION-A,20240708,2,,
POSITION-C,20240708,1,weekday,100
POSITION-A,20240709,2,,
POSITION-C,20240709,1,weekday,100
POSITION-B,20240718,2,,
POSITION-C,20240718,1,weekday,100
POSITION-B,20240719,2,,
POSITION-C,20240719,1,weekday,100
```
date,exception_type,service_id,run_id,employee_id
20240708,2,,EMPLOYEE-A
20240708,1,weekday,100,EMPLOYEE-C
20240709,2,,EMPLOYEE-A
20240709,1,weekday,100,EMPLOYEE-C
20240718,2,,EMPLOYEE-B
20240718,1,weekday,100,EMPLOYEE-C
20240719,2,,EMPLOYEE-B
20240719,1,weekday,100,EMPLOYEE-C
```

## Multi-week roster positions

At some agencies (especially in Europe), roster positions repeat every two weeks. In TODS, this can be represented by having the first and second weeks be two different roster positions, and using [`employee_roster.txt`](/docs/spec.md#employee_rostertxt) to assign employees to each roster position each week.

In this example, there's one run per day on weekdays only. Position A works Mondays and Tuesdays. Position B works Thursdays and Fridays. They trade off on Wednesdays, so each position works an average of 2½ days per week.

**[`calendar.txt`](https://gtfs.org/documentation/schedule/reference/#calendartxt)**

```
service_id,monday,tuesday,wednesday,thursday,friday,saturday,start_date,end_date
weekday,1,1,1,1,1,0,0,20240701,20240728
```

**[`roster_positions.txt`](/docs/spec.md#roster_positionstxt)**


```
roster_position_id,start_date,end_date,monday_service_id,monday_run_id,tuesday_service_id,tuesday_run_id,wednesday_service_id,wednesday_run_id,thursday_service_id,thursday_run_id,friday_service_id,friday_run_id,saturday_service_id,saturday_run_id,sunday_service_id,sunday_run_id
POSITION-A-WEEK-1,20240701,20240728,weekday,100,weekday,100,weekday,100,,,,,,,,
POSITION-A-WEEK-2,20240701,20240728,weekday,100,weekday,100,,,,,,,,,,
POSITION-B-WEEK-1,20240701,20240728,,,,,,,weekday,100,weekday,100,,,,
POSITION-B-WEEK-2,20240701,20240728,,,,,weekday,100,weekday,100,weekday,100,,,,
```

**[`employee_roster.txt`](/docs/spec.md#employee_rostertxt)**

```
roster_position_id,start_date,end_date,employee_id
POSITION-A-WEEK1,20240701,20240707,EMPLOYEE-A
POSITION-B-WEEK1,20240701,20240707,EMPLOYEE-B
POSITION-A-WEEK2,20240707,20240714,EMPLOYEE-A
POSITION-B-WEEK2,20240707,20240714,EMPLOYEE-B
POSITION-A-WEEK1,20240715,20240721,EMPLOYEE-A
POSITION-B-WEEK1,20240715,20240721,EMPLOYEE-B
POSITION-A-WEEK2,20240722,20240728,EMPLOYEE-A
POSITION-B-WEEK2,20240722,20240728,EMPLOYEE-B
```

## Rotating assignments

At some agencies (especially in the UK), employees rotate among all roster positions over many weeks. In TODS, this can be represented by assigning each employee to a new roster position each week.

In this example, there are 5 employees and 5 roster positions. Over a calendar of 3 weeks, each employee will work 3 of the 5 positions.

**[`calendar.txt`](https://gtfs.org/documentation/schedule/reference/#calendartxt)**

```
service_id,monday,tuesday,wednesday,thursday,friday,saturday,start_date,end_date
weekday,1,1,1,1,1,0,0,20240701,20240721
```

**[`roster_positions.txt`](/docs/spec.md#roster_positionstxt)**


```
roster_position_id,start_date,end_date,monday_service_id,monday_run_id,tuesday_service_id,tuesday_run_id,wednesday_service_id,wednesday_run_id,thursday_service_id,thursday_run_id,friday_service_id,friday_run_id,saturday_service_id,saturday_run_id,sunday_service_id,sunday_run_id
POSITION-1,20240701,20240721,weekday,101,weekday,101,weekday,101,weekday,101,weekday,101,,,,
POSITION-2,20240701,20240721,weekday,102,weekday,102,weekday,102,weekday,102,weekday,102,,,,
POSITION-3,20240701,20240721,weekday,103,weekday,103,weekday,103,weekday,103,weekday,103,,,,
POSITION-4,20240701,20240721,weekday,104,weekday,104,weekday,104,weekday,104,weekday,104,,,,
POSITION-5,20240701,20240721,weekday,105,weekday,105,weekday,105,weekday,105,weekday,105,,,,
```

**[`employee_roster.txt`](/docs/spec.md#employee_rostertxt)**

```
roster_position_id,start_date,end_date,employee_id
POSITION-1,20240701,20240707,EMPLOYEE-A
POSITION-2,20240701,20240707,EMPLOYEE-B
POSITION-3,20240701,20240707,EMPLOYEE-C
POSITION-4,20240701,20240707,EMPLOYEE-D
POSITION-5,20240701,20240707,EMPLOYEE-E
POSITION-1,20240708,20240714,EMPLOYEE-E
POSITION-2,20240708,20240714,EMPLOYEE-A
POSITION-3,20240708,20240714,EMPLOYEE-B
POSITION-4,20240708,20240714,EMPLOYEE-C
POSITION-5,20240708,20240714,EMPLOYEE-D
POSITION-1,20240715,20240721,EMPLOYEE-D
POSITION-2,20240715,20240721,EMPLOYEE-E
POSITION-3,20240715,20240721,EMPLOYEE-A
POSITION-4,20240715,20240721,EMPLOYEE-B
POSITION-5,20240715,20240721,EMPLOYEE-C
```

## Minor schedule adjustment

In this example, due to track work, the schedule has been minorly changed one day. There are new trip times, trip IDs, run event times, and a new service ID.

If the roster files specify service IDs (which is recommended), then either [`roster_dates.txt`](/docs/spec.md#roster_datestxt) or [`employee_run_dates.txt`](/docs/spec.md#employee_run_datestxt) must be used to assign the roster position or employee to the new `(service_id, run_id)` pair, i.e. `(trackwork, 100)` instead of `(weekday, 100)`.

However, in this example, the roster does not specify the service ID in [`roster_positions.txt`](/docs/spec.md#roster_positionstxt). Therefore, the employee is assigned to run 100 on whichever service is active. Since both the regular and replacement runs have run ID `100`, on the day of the exception, the employee will be implicitly assigned to `(trackwork, 100)` without needing to specify that in the roster files.

The spec describes this situation in [Service IDs in Rosters](/docs/spec/index.md#service-ids-in-rosters).

**[`calendar.txt`](https://gtfs.org/documentation/schedule/reference/#calendartxt)**

```
service_id,monday,tuesday,wednesday,thursday,friday,saturday,start_date,end_date
weekday,1,1,1,1,1,0,0,20250201,20240728
```

**[`calendar_dates.txt`](https://gtfs.org/documentation/schedule/reference/#calendar_datestxt)**

The trackwork is on Friday, February 2.

```
service_id,date,exception_type
weekday,20250207,2
trackwork,20250207,1
```

**[`run_events.txt`](/docs/spec.md#run_eventstxt)**

Because of the track work, travel is slower and the times are adjusted.

```
service_id,run_id,event_sequence,event_type,trip_id,start_location,start_time,end_location,end_time
weekday,100,1,Operator,1001,suburb,08:00:00,downtown,09:00:00
weekday,100,2,Operator,1002,downtown,17:00:00,suburb,18:00:00
trackwork,100,1,Operator,2001,suburb,08:00:00,downtown,09:30:00
trackwork,100,2,Operator,2002,downtown,16:30:00,suburb,18:00:00
```

**[`roster_positions.txt`](/docs/spec.md#roster_positionstxt)**

Note that the service ID fields are left blank.

```
roster_position_id,start_date,end_date,monday_service_id,monday_run_id,tuesday_service_id,tuesday_run_id,wednesday_service_id,wednesday_run_id,thursday_service_id,thursday_run_id,friday_service_id,friday_run_id,saturday_service_id,saturday_run_id,sunday_service_id,sunday_run_id
POSITION,20250201,20250228,,100,,100,,100,,100,,100,,,,,
```

**[`employee_roster.txt`](/docs/spec.md#employee_rostertxt)**

```
roster_position_id,start_date,end_date,employee_id
POSITION,20250201,20250228,EMPLOYEE
```
