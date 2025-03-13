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

Here are example algorithms (written in pseudocode) for a couple typical lookups a consumer might do in the roster files. These examples show how to connect data across all the roster files.

This algorithm will cover edge cases and work for both simple and complex cases. If you know you have simpler data, you may be able to use simpler rules.

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
        employees_on_run =
            SELECT employee_id FROM employee_run_dates.txt
            WHERE date = ${service_date}
            AND run_id = ${run_id}
            AND (service_id IS NULL OR service_id = ${service_id})
        employees_on_trip.add(employees_on_run)

    return employees_on_trip
```

### Given an employee ID and date, look up which trips they're working on that day

```ruby
# Returns a list of trip IDs
def trips_for_employee(employee_id, service_date):
    # List of (service_id, run_id) pairs, or (NULL, run_id) if the data omits the service id
    runs =
        SELECT (service_id, run_id) FROM employee_run_dates.txt
        WHERE date = ${service_date}
        AND employee_id = ${employee_id}

    # Now we know which runs the employee is working on this date. Look up the trips on those runs in run_events.txt
    trip_ids = []
    # note service_id might be NULL here
    for (service_id, run_id) in runs:
        trip_ids.add(trips_for_run(service_id, run_id, service_date))
    return trip_ids

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

## Minor schedule adjustment

In this example, due to track work, the schedule has been minorly changed one day. There are new trip times, trip IDs, run event times, and a new service ID.

If the service IDs is included in [`employee_run_dates.txt`](/docs/spec/index.md#employee_run_datestxt) (which is recommended), then the service ID must be changed on the day of the track work.

However, in this example, the service IDs are omitted. Therefore, the employee is assigned to run 100 on whichever service is active. Since both the regular and replacement runs have run ID `100`, on the day of the exception, the employee will be implicitly assigned to `(trackwork, 100)` without needing to specify that in [`employee_run_dates.txt`](/docs/spec/index.md#employee_run_datestxt).

The spec describes this situation in [Service IDs in Rosters](/docs/spec/index.md#service-ids-in-rosters).

**[`calendar.txt`](https://gtfs.org/documentation/schedule/reference/#calendartxt)**

```csv
service_id,monday,tuesday,wednesday,thursday,friday,saturday,start_date,end_date
weekday,1,1,1,1,1,0,0,20250201,20240714
```

**[`calendar_dates.txt`](https://gtfs.org/documentation/schedule/reference/#calendar_datestxt)**

The trackwork is on Friday, February 7.

```csv
service_id,date,exception_type
weekday,20250207,2
trackwork,20250207,1
```

**[`run_events.txt`](/docs/spec.md#run_eventstxt)**

Because of the track work, travel is slower and the times are adjusted.

```csv
service_id,run_id,event_sequence,event_type,trip_id,start_location,start_time,end_location,end_time
weekday,100,1,Operator,1001,suburb,08:00:00,downtown,09:00:00
weekday,100,2,Operator,1002,downtown,17:00:00,suburb,18:00:00
trackwork,100,1,Operator,2001,suburb,08:00:00,downtown,09:30:00
trackwork,100,2,Operator,2002,downtown,16:30:00,suburb,18:00:00
```

**[`employee_run_dates.txt`](/docs/spec/index.md#employee_run_datestxt)**

The does run `100` on every day. On February 7, that's `(trackwork, 100)`. On all other days that's `(weekday, 100)`.

```csv
date,employee_id,service_id,run_id
20250203,A,,100
20250204,A,,100
20250205,A,,100
20250206,A,,100
20250207,A,,100
20250210,A,,100
20250211,A,,100
20250212,A,,100
20250213,A,,100
20250214,A,,100
```
