# Rostering Examples

A series of examples about how to use [roster.txt](/docs/spec.md#rostertxt), [roster_dates.txt](/docs/spec.md#roster_datestxt), [employee_roster.txt](/docs/spec.md#employee_rostertxt), and [employee_run_dates.txt](/docs/spec.md#employee_run_datestxt) to assign employees to roster positions and runs.

## Simplest example: employee_run_dates.txt only

The simplest way to assign employees to runs is to use [`employee_run_dates.txt`](/docs/spec.md#employee_run_datestxt). This will require one row per employee per date.

In this example, `A` and `B` work Saturday Feb 1 and Wednesday Feb 5 through Friday Feb 7. `C` and `D` work Sunday Feb 2 through Tuesday Feb 4.

**[`calendar.txt`](https://gtfs.org/documentation/schedule/reference/#calendartxt)**

```csv
service_id,monday,tuesday,wednesday,thursday,friday,saturday,start_date,end_date
weekend,0,0,0,0,0,1,1,20250201,20250207
weekday,1,1,1,1,1,0,0,20250201,20250207
```

February 1, 2025 was a Saturday.

**[`run_events.txt`](/docs/spec.md#run_eventstxt)**

For this example, the purpose of this file is just to show which runs exist. Real runs would have more interesting data.

```csv
service_id,run_id,event_sequence,event_type,start_location,start_time,end_location,end_time
weekend,101,1,work,station,09:00:00,station,17:00:00
weekend,102,1,work,station,09:00:00,station,17:00:00
weekday,103,1,work,station,09:00:00,station,17:00:00
weekday,104,1,work,station,09:00:00,station,17:00:00
```

**[`employee_run_dates.txt`](/docs/spec.md#employee_run_datestxt)**

```csv
date,employee_id,service_id,run_id
20250201,A,weekend,101
20250201,B,weekend,102
20250202,C,weekend,101
20250202,D,weekend,102
20250203,C,weekday,103
20250203,D,weekday,104
20250204,C,weekday,103
20250204,D,weekday,104
20250205,A,weekday,103
20250205,B,weekday,104
20250206,A,weekday,103
20250206,B,weekday,104
20250207,A,weekday,103
20250207,B,weekday,104
```

## Example algorithm for looking up data

Here are example algorithms (written in pseudocode) for a couple typical lookups a consumer might do with `employee_run_dates.txt`.

### Given a trip ID and date, look up which employees are working on that trip

```ruby
# Returns a list of employee IDs
def employees_on_trip(service_date, trip_id):
    # List of (service_id, run_id). There may be 0 (run_events.txt is incomplete), 1, or many (if multiple people work on that trip).
    runs_on_trip =
        SELECT DISTINCT (service_id, run_id) FROM run_events.txt
        WHERE run_events.trip_id = ${trip_id}

    employees_on_trip = []
    for each (service_id, run_id) in runs_on_trip:
        # should be at most one employee assigned to each run
        employees_on_run =
            SELECT employee_id FROM employee_run_dates.txt
            WHERE date = ${service_date}
            AND run_id = ${run_id}
            AND service_id = ${service_id}
        employees_on_trip.add(employees_on_run)

    return employees_on_trip
```

### Given an employee ID and date, look up which trips they're working on that day

```ruby
# Returns a list of trip IDs
def trips_for_employee(employee_id, service_date):
    # List of (service_id, run_id) pairs
    runs =
        SELECT (service_id, run_id) FROM employee_run_dates.txt
        WHERE date = ${service_date}
        AND employee_id = ${employee_id}

    # Now we know which runs the employee is working on this date. Look up the trips on those runs in run_events.txt
    trip_ids = []
    for (service_id, run_id) in runs:
        trip_ids.add(
            SELECT trip_id FROM run_events.txt
            WHERE run_id = ${run_id}
            AND service_id = ${service_id}
        )
    return trip_ids
```
