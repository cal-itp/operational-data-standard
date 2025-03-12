
# Reference

The Transit Operational Data Standard was last updated on April 3, 2024 (v2.0 DRAFT). View the full [revision history](./revision-history.md).

## Dataset Files

### Structure

There are two types of files used in the TODS standard:

- **Supplement files**, used to add, modify, and delete information from public GTFS files to model the operational service for internal purposes (with a `_supplement` filename suffix).
- **TODS-Specific files**, used to model operational elements not currently defined in the GTFS standard.

All files are optional.

### Files

| **File Name** | **Type** | **Description** |
| --- | --- | --- |
| trips_supplement.txt | Supplement | Supplements and modifies GTFS [trips.txt](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#tripstxt) with deadheads and other non-public trip information. |
| stops_supplement.txt | Supplement | Supplements and modifies GTFS [stops.txt](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#stopstxt) with internal stop locations, waypoints, and other non-public stop information.|
| stop_times_supplement.txt | Supplement | Supplements and modifies GTFS [stop_times.txt](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#stop_timestxt) with non-public times at which trips stop at locations, `stop_times` entries for non-public trips, and related information. |
| routes_supplement.txt | Supplement | Supplements and modifies GTFS [routes.txt](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#routestxt) with internal route identifiers and other non-public route identification. |
| run_events.txt | TODS-Specific | Lists all trips and other scheduled activities to be performed by a member of personnel during a run. |
| roster.txt | TODS-Specific | Lists the runs that a roster position is assigned to work on a typical week. |
| roster_dates.txt | TODS-Specific | Lists the runs that a roster position is assigned to work on specific dates. |
| employee_roster.txt | TODS-Specific | Lists which employee is assigned to which roster position. |
| employee_run_dates.txt | TODS-Specific | Exceptions to roster assignments. Assigns employees directly to runs on specific dates. |

_The use of the Supplement standard to modify other GTFS files is not yet formally adopted into the specification and remains subject to change. Other files may be formally adopted in the future._

## Supplement Files

### Structure

The fields in all Supplement files match those defined in the corresponding file's [GTFS specification](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md).

The overall premise is to update and add data to GTFS, which is accomplished by either updating matching values or adding rows entirely.

Each entry in a Supplement file is paired with its matching entry in the corresponding GTFS file using the [GTFS file's Primary Key](https://gtfs.org/schedule/reference/#dataset-attributes), i.e. the fields that uniquely identify the row. If no match is found, the Supplement file's entry is added to the GTFS file in its entirety.

The standard also supports the removal of rows in their entirety.

### Evaluation

Each row in a Supplement file shall be evaluated as follows:

1. If the row's Primary Key is defined in the corresponding GTFS file, and the `TODS_delete` field is defined and equal to `1`, remove the corresponding row from the GTFS file.
2. If the row's Primary Key is defined in the corresponding GTFS file, and the `TODS_delete` field is not defined or not equal to `1`, set or update any fields with defined values in the Supplement file to those values in the corresponding GTFS file.
3. If the row's Primary Key is NOT defined in the corresponding GTFS file, add the row to the corresponding GTFS file.

In other words, where a Primary Key matches, the row is either removed or any non-empty values in the row are used to _update_ the corresponding GTFS values. Where a Primary Key match does not exist, the entire row is added.

### Example

GTFS `stops.txt`:

```csv
stop_id,stop_name,stop_desc,stop_url
1,One,Unmodified in TODS,example.com/1
2,Two,Deleted in TODS,example.com/2
3,Three,Will be modified in TODS,example.com/3
```

TODS `stops_supplement.txt`:

```CSV
stop_id,stop_name,stop_desc,TODS_delete
2,,,1
3,,Has been modified by TODS,
4,Four,New in TODS,
```

Effective `stops.txt` after merging the supplement file:

```CSV
stop_id,stop_name,stop_desc,stop_url
1,One,Unmodified in TODS,example.com/1
3,Three,Has been modified by TODS,example.com/3
4,Four,New in TODS,
```

_Note that the station name "Three" was not modified, and the whole column stop_url was omitted and not modified._

### Implications and Guidance

- As blank fields are ignored, data to be removed should either be overwritten with a new value or have their entire row deleted using the `TODS_delete` field.
- As processing of files is non-sequential, it is prohibited to both delete and re-add a row with identical Primary Keys in the same Supplement file.
- If a row contains defined values besides the Primary Key and a `TODS_delete` value of `1`, the row shall be removed and other values in that row will be ignored.
- When adding rows and updating values, be certain to ensure the values are being updated based on their column values (e.g. if GTFS has fields of `trip_id,route_id,trip_short_name` and the TODS Supplement file has fields of `trip_id,trip_short_name`, be certain that values are mapping to the correct fields without assuming column headers are identical).
- When deleting a row in a file, any references to that field/value shall be ignored. Thus, it is important to ensure references to that row are either redefined or are being intentionally omitted. For example:
    - When deleting a trip via `trips_supplement.txt`, all of that trip's entires in `stop_times.txt` will not be associated with a valid trip and would thus be ignored.
    - When deleting a route via `routes_supplement.txt`, all trips using that route would not be associated with a valid route and would thus be ignored _UNLESS_ the `route_id` on the affected trips is updated via the `trips_supplement.txt` file.
- After modifying static GTFS content to incorporate the TODS Supplement modifications, the resulting data ("TODS-Supplemented GTFS") should form a valid GTFS dataset, with the limited exception of missing data that should be ignored per the above.

### TODS-Specific Fields

In addition to the fields defined in GTFS, specific fields for use within TODS are denoted by a `TODS_` field prefix.

| **File** | **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- | --- |
| Any Supplement file | `TODS_delete` | Enum | Optional | (blank) - Update other fields; do not delete.<br>`1` - Deletes the GTFS row in the corresponding file whose Primary Key matches the value in the Supplement file's row. |
| `trips_supplement.txt` | `TODS_trip_type` | Text | Optional | Defines the type of the trip if distinct from a standard revenue trip. |
| `stops_supplement.txt` | `TODS_location_type` | Text | Optional | Defines the type of the location if distinct from a standard GTFS location type. Where defined, the GTFS `location_type` shall be ignored. |

## TODS-Specific File Definitions

### `run_events.txt`

Primary Key: (`service_id`, `run_id`, `event_sequence`)

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| `service_id` | ID referencing `calendar.service_id` or `calendar_dates.service_id` | Required | Identifies a set of dates when the run is scheduled to take place. |
| `run_id` | ID | Required | A run is uniquely determined by a `service_id`, `run_id` pair. Runs with the same `run_id` on different `service_id`s are considered different runs. |
| `event_sequence` | Non-negative integer | Required | The order of this event within a run. Must be unique within one (`service_id`, `run_id`). See [more detail below](#event_sequence-and-event-times) about how order is defined. |
| `piece_id` | ID | Optional | Identifies the piece within the run that the event takes place.<br /><br />May be blank if the event takes place out of a piece, like a break, or if the agency does not use piece IDs. |
| `block_id` | ID referencing `trips.block_id` | Optional | Identifies the block to which the run event belongs.<br /><br />This field is always optional. May exist even if `trip_id` does not (e.g. if an event represents a run-as-directed block with no scheduled trips). May exist even if `trip_id` exists and the associated trip in `trips.txt` doesn't have a `block_id`. May be omitted even if `trip_id` exists and the associated trip in `trips.txt` has a `block_id`.<br /><br />If `block_id` is set, `trip_id` is set, and the associated trip in `trips.txt` has a `block_id`, then the two `block_id`s must not be different. |
| `job_type` | Text | Optional | The type of job that the employee is doing, in a human-readable format. e.g. "Assistant Conductor". Producers may use any values, but should be consistent.<br /><br />A single run may include more than one `job_type` throughout the day if the employee has multiple responsibilities, e.g. an "Operator" in the morning and a "Shifter" in the afternoon. |
| `event_type` | Text | Required | The type of event that the employee is doing, in a human-readable format. e.g. "Sign-in". Producers may use any values, but should be consistent. Consumers may ignore events with an `event_type` that they don't recognize. |
| `trip_id` | ID referencing `trips.trip_id` | Optional | If this run event corresponds to working on a trip, identifies that trip. |
| `start_location` | ID referencing `stops.stop_id` | Required | Identifies where the employee starts working this event.<br /><br />If `trip_id` is set (and `mid_trip_start` is not `1`), this should be the `stop_id` of the first stop of the trip in `stop_times.txt` (after applying any trip supplement). If `start_mid_trip` is `1`, this should be the location where the employee starts working, matching a `stop_id` in the middle of the supplemented trip. |
| `start_time` | Time | Required | Identifies the time when the employee starts working this event.<br /><br />If `trip_id` is set (and `mid_trip_start` is not `1`), this corresponds to the time of the first stop of the trip in `stop_times.txt` (after applying any trip supplement). If `start_mid_trip` is `1`, this time corresponds to a stop time in the middle of the supplemented trip, when the employee starts working on the trip. Note that this time may not exactly match `stop_times.txt` `arrival_time` or `departure_time` if the employee is considered to be working for a couple minutes before the trip departs. This field is about when the employee is working, and consumers who care about the the trip times should check `stop_times.txt` instead. |
| `start_mid_trip` | Enum | Optional | Indicates whether the event begins at the start of the trip or in the middle of the trip (after applying any trip supplement).<br /><br />`0` (or blank) - Run event is not associated with a trip, or no information about whether the run event starts mid-trip<br />`1` - Run event starts mid-trip<br />`2` - Run event does not start mid-trip |
| `end_location` | ID referencing `stops.stop_id` | Required | Identifies where the employee stops working this event.<br /><br />If `trip_id` is set (and `mid_trip_end` is not `1`), this should be the `stop_id` of the last stop of the trip in `stop_times.txt` (after applying any trip supplement). If `end_mid_trip` is `1`, this should be the location where the employee stops working, matching a `stop_id` in the middle of the supplemented trip. |
| `end_time` | Time | Required | Identifies the time when the employee stops working this event.<br /><br />If `trip_id` is set (and `mid_trip_end` is not `1`), this corresponds to the time of the last stop of the trip in `stop_times.txt` (after applying any trip supplement). If `end_mid_trip` is `1`, this time corresponds to a stop time in the middle of the supplemented trip, when the employee stops working on the trip. Note that this time may not exactly match `stop_times.txt` `arrival_time` or `departure_time` if the employee is considered to be working for a couple minutes after the trip finishes. This field is about when the employee is working, and consumers who care about the the trip times should check `stop_times.txt` instead. |
| `end_mid_trip` | Enum | Optional | Indicates whether the event ends at the end of the trip or in the middle of the trip (after applying any trip supplement).<br /><br />`0` (or blank) - Run event is not associated with a trip, or no information about whether the run event ends mid-trip<br />`1` - Run event ends mid-trip<br />`2` - Run event does not end mid-trip |

#### `event_sequence` and Event Times

`event_sequence` is required and unique within a run so it can be used in the Primary Key to uniquely identify events.

Within one run, `event_sequence` values should increase throughout the day but do not have to be consecutive.

Within one run, if two events both have `trip_id` set, they must not overlap in time (based on `start_time` and `end_time`). Employees cannot be on two trips at once, or have multiple duties on the same trip at the same time. Having a zero-minute overlap is allowed, to allow consecutive trips without layovers, and to allow trips with 0-minute durations, which some agencies use for bookkeeping reasons.

Events that don't have `trip_id` set may overlap in time with any other events. This is to allow events that represent a large portion of a day (such as time that an employee is available to work), regardless of what other duties or trips they have during that time.

Because some events may overlap in time, it may not be possible to choose a single order for events within a run that's correct for all uses. Producers should use `event_sequence` to define a reasonable order. If a consumer cares about exactly how overlapping events are ordered, they should sort based on the time fields and `event_type` instead.

#### `run_events` Notes

- Multiple `run_event`s may refer to the same `trip_id`, if multiple employees work on that trip.
- Events may have gaps between the end time of one event and the start time of the next. e.g. if an operator's layovers aren't represented by an event.
- `start_time` may equal `end_time` for an event that's a single point in time (such as a report time) without any duration.
- Recommended sort order: `service_id`, `run_id`, `event_sequence`.

### `roster.txt`

This file defines roster positions, groupings of work across multiple runs on multiple dates that an employee can be assigned to all at once.

Exceptions to these dates may be listed in [`roster_dates.txt`](#roster_datestxt).

Employees are assigned to these roster positions in [`employee_roster.txt`](#employee_rostertxt).

Primary Key: `roster_position_id`

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| `roster_position_id` | Unique ID | Required | Unique within dataset |
| `start_date` | Date | Required | First service day that the roster position works. |
| `end_date` | Date | Required | Last service day tha the roster position works. This day is included in the interval. |
| `monday_service_id` | ID referencing `run_events.txt` | Conditionally Required | Identifies the run this roster does on Mondays. Runs are identified by the pair `(service_id, run_id)`. Forbidden if `monday_run_id` is blank. Optional and recommended if `monday_run_id` is present. Required in some cases to avoid ambiguity. See [Service IDs in Rosters](#service-ids-in-rosters). |
| `monday_run_id` | ID referencing `run_events.txt` | Optional | Identifies the run this roster does on Mondays. If blank, this roster does not work on Mondays. |
| `tuesday_service_id` | ID referencing `run_events.txt` | Conditionally Required | |
| `tuesday_run_id` | ID referencing `run_events.txt` | Optional | |
| `wednesday_service_id` | ID referencing `run_events.txt` | Conditionally Required | |
| `wednesday_run_id` | ID referencing `run_events.txt` | Optional | |
| `thursday_service_id` | ID referencing `run_events.txt` | Conditionally Required | |
| `thursday_run_id` | ID referencing `run_events.txt` | Optional | |
| `friday_service_id` | ID referencing `run_events.txt` | Conditionally Required | |
| `friday_run_id` | ID referencing `run_events.txt` | Optional | |
| `saturday_service_id` | ID referencing `run_events.txt` | Conditionally Required | |
| `saturday_run_id` | ID referencing `run_events.txt` | Optional | |
| `sunday_service_id` | ID referencing `run_events.txt` | Conditionally Required | |
| `sunday_run_id` | ID referencing `run_events.txt` | Optional | |

#### Service IDs in Rosters

Run IDs may be non-unique, they may be duplicated across services. E.g. there may be a "Run 100" on both Weekday and Weekend services. So a run as described in [`run_events.txt`](#run_eventstxt) is uniquely identified by a `(service_id, run_id)` pair. It is recommeded that producers include both a Service ID and Run ID when identifying a run in `roster.txt`, [`roster_dates.txt`](#roster_datestxt), and [`employee_run_dates.txt`](#employee_run_datestxt).

If a Run ID is included but a Service ID isn't, then the roster position or employee is assigned to work on whichever run in [`run_events.txt`](#run_eventstxt) has that Run ID and is on a service that is active that service day, according to GTFS [`calendar.txt`](https://gtfs.org/documentation/schedule/reference/#calendartxt)/[`calendar_dates.txt`](https://gtfs.org/documentation/schedule/reference/#calendar_datestxt). (If this would be ambiguous because there are mutliple runs with the same `run_id` active on the same day, and therefore multiple `(service_id, run_id)` pairs it could refer to, then the Service ID is required.)

This is allowed as a shortcut for producers to reduce the level of duplication in the roster file if a roster position works runs with the same ID on different days. For example, if there's a minor schedule change one day due to track work, that day must be on a different Service ID to give new trip and run times. But if a roster position works "Run 100" on both the regular and modified service, and the roster file leaves the Service ID field blank, then the roster file doesn't need an exception for that day because it refers to "Run 100" on whichever service is happening.

More in-depth examples and instructions on how to look up which run an employee is doing are given in [the examples](./examples/rostering.md#given-an-date-and-employee-look-up-which-trips-theyre-doing-that-day).

### `roster_dates.txt`

Defines exceptions to [`roster.txt`](#rostertxt), similar to how [`calendar_dates.txt`](https://gtfs.org/documentation/schedule/reference/#calendar_datestxt) defines exceptions to [`calendar.txt`](https://gtfs.org/documentation/schedule/reference/#calendartxt).

This can be used to define holidays, vacations that are built into the roster position, or other exceptions.

Dates may be added before the `start_date` or after the `end_date` defined in [`roster.txt`](#rostertxt).

After evaluating [`roster.txt`](#rostertxt) and `roster_dates.txt`, each run can only be assigned to one roster position on each date. A roster position may be scheduled to do multiple runs on the same date.

This file may be used even when [`roster.txt`](#rostertxt) is not defined, in which case each roster position is made up of the dates added in this file. This may be useful for agencies whose rosters are very irregular. In this case, the `exception_type` column can be omitted because every row is adding a date, which is the default when the column is blank.

Primary Key: `*`

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| `roster_position_id` | ID referencing [`roster.txt`](#rostertxt) or ID | Required | If `exception_type` is `1`, then the ID does not have to appear in [`roster.txt`](#rostertxt). This file may define new roster positions. |
| `date` | Date | Required | Date when exception occurs. |
| `exception_type` | Enum | Optional | `1` (or blank) - The run is added to this roster for the specified date.<br />`2` - The roster will not work its regular run on this date. |
| `service_id` | ID referencing `run_events.txt` | Conditionally Required | Part of the Run ID, which is refered to as `(service_id, run_id)`. Optional and recommended. Required in some cases to avoid ambiguity. See [Service IDs in Rosters](#service-ids-in-rosters). |
| `run_id` | ID referencing `run_events.txt` | Conditionally Required | The run that's either added or removed from this roster. Required if `exception_type` is `1`. Optional if `exception_type` is `2`. If `exception_type` is `2` and `run_id` is not blank, then it must match the Run ID that the roster was scheduled to do on this date according to [`roster.txt`](#rostertxt). |

### `employee_roster.txt`

Describes which employees are scheduled to which roster positions on which dates.

Primary Key: `(roster_position_id, start_date)`

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| `roster_position_id` | ID referencing `roster.txt` or `roster_dates.txt` | Required | |
| `start_date` | Date | Required | |
| `end_date` | Date | Required | Included in the interval. |
| `employee_id` | ID | Required | |

Each roster position can only be assigned to one employee on each date. Employees may be scheduled to more than one roster position on the same date.

### `employee_run_dates.txt`

Describes which employees are scheduled to which runs on which dates. If [`employee_roster.txt`](#employee_rostertxt) is used, then describes exceptions to that schedule.

Primary Key: `*`

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| `date` | Date | Required | |
| `employee_id` | ID | Required | References an agency's external systems. Employee IDs are not used elsewhere in TODS. |
| `exception_type` | Enum | Optional | `1` (or blank) - The run is assigned to this employee on the specified date.<br />`2` - The employee will not work this run on this date. |
| `service_id` | ID referencing `run_events.txt` | Conditionally Required | Part of the Run ID, which is refered to as `(service_id, run_id)`. Optional and recommended. Required in some cases to avoid ambiguity. See [Service IDs in Rosters](#service-ids-in-rosters). |
| `run_id` | ID referencing `run_events.txt` | Required | The run that's either added or removed from this employee's schedule. If `exception_type` is `2` and `run_id` is not blank, then it must match a Run ID that the employee was scheduled to do on this date according to `employee_roster.txt`, `roster.txt` and `roster_dates.txt`. |

If a feed doesn't represent roster positions, it can still assign employees to runs by putting every run for every date in this file. In that case, the `exception_type` column can be omitted because every row would be adding a date, which is the default when the column is blank. [Example](./examples/rostering.md#simplest-example-employee_run_datestxt-only).

Each run can only be assigned to one employee on each date. Employees may be scheduled to more than one run on the same date.
