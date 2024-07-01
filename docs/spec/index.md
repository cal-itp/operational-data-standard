
# Reference

The Transit Operational Data Standard was last updated on April 3, 2024 (v2.0 DRAFT). View the full [revision history](./revision-history.md).

## Dataset Files

### Structure

There are two types of files used in the TODS standard:

- **Supplement files**, used to add, modify, and delete information from public GTFS files to model the operational service for internal purposes (with a `_supplement` filename suffix).
- **TODS-Specific files**, used to model operational elements not currently defined in the GTFS standard.

### Files

| **File Name** | **Type** | **Description** |
| --- | --- | --- |
| trips_supplement.txt | Supplement | Supplements and modifies GTFS [trips.txt](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#tripstxt) with deadheads and other non-public trip information. |
| stops_supplement.txt | Supplement | Supplements and modifies GTFS [stops.txt](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#stopstxt) with internal stop locations, waypoints, and other non-public stop information.|
| stop_times_supplement.txt | Supplement | Supplements and modifies GTFS [stop_times.txt](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#stop_timestxt) with non-public times at which trips stop at locations, `stop_times` entries for non-public trips, and related information. |
| routes_supplement.txt | Supplement | Supplements and modifies GTFS [routes.txt](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#routestxt) with internal route identifiers and other non-public route identification. |
| run_events.txt | TODS-Specific | Lists all trips and other scheduled activities to be performed by a member of personnel during a run. |

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
| `run_id` | ID | Required | |
| `event_sequence` | Non-negative integer | Required | The order of this event within a run. Must be unique within one (`service_id`, `run_id`). See [more detail below](#event_sequence) about how order is defined. |
| `piece_id` | ID | Optional | Identifies the piece within the run that the event takes place.<br /><br />May be blank if the event takes place out of a piece, like a break, or if the agency does not use piece IDs. |
| `block_id` | ID referencing `trips.block_id` | Optional | Identifies the block to which the run event belongs. If `block_id` exists, `trip_id` exists, and that trip's entry in `trips.txt` has a `block_id`, then the two `block_id`s must match. May exist even if `trip_id` does not (e.g. if an event represents a run-as-directed block with no scheduled trips). |
| `job_type` | Text | Optional | The type of job that the employee is doing, in a human-readable format. e.g. "Assistant Conductor". Producers may use any values, but should be consistent.<br /><br />A single run may include more than one `job_type` throughout the day if the employee has multiple responsibilities, e.g. an "Operator" in the morning and a "Shifter" in the afternoon. |
| `event_type` | Text | Required | The type of event that the employee is doing, in a human-readable format. e.g. "Sign-in". Producers may use any values, but should be consistent. Consumers may ignore events with an `event_type` that they don't recognize. |
| `trip_id` | ID referencing `trips.trip_id` | Optional | If this run event corresponds to working on a trip, identifies that trip. |
| `start_location` | ID referencing `stops.stop_id` | Required | Identifies where the employee starts this event.<br /><br />If `trip_id` is set (and `mid_trip_start` is not `1`), this should be the first stop of the trip (after applying any trip supplement). If `start_mid_trip` is `1`, this should instead be the location where the employee starts, in the middle of the supplemented trip. |
| `start_time` | Time | Required | Identifies the time when the employee starts this event.<br /><br />If `trip_id` is set (and `mid_trip_start` is not `1`), this should be the time of the first stop of the trip (after applying any trip supplement). If `start_mid_trip` is `1`, this should instead be the time when the employee starts, in the middle of the supplemented trip. |
| `start_mid_trip` | Enum | Conditionally required | Indicates whether the event begins at the start of the trip or in the middle of the trip (after applying any trip supplement).<br /><br />`0` (or blank) - Run event does not start mid-trip<br />`1` - Run event starts mid-trip<br /><br />Required if the run event begins with a mid-trip relief. Optional otherwise. Recommended to leave this field blank if `trip_id` is not set. |
| `end_location` | ID referencing `stops.stop_id` | Required | Identifies where the employee ends this event.<br /><br />If `trip_id` is set (and `mid_trip_end` is not `1`), this should be the last stop of the trip (after applying any trip supplement). If `end_mid_trip` is `1`, this should instead be the location where the employee ends, in the middle of the supplemented trip. |
| `end_time` | Time | Required | Identifies the time when the employee ends this event.<br /><br />If `trip_id` is set (and `mid_trip_end` is not `1`), this should be the time of the last stop of the trip (after applying any trip supplement). If `end_mid_trip` is `1`, this should instead be the time when the employee ends, in the middle of the supplemented trip.<br /><br />Must be greater than or equal to `start_time`. |
| `end_mid_trip` | Enum | Conditionally required | Indicates whether the event ends at the end of the trip or in the middle of the trip (after applying any trip supplement).<br /><br />`0` (or blank) - Run event does not end mid-trip<br />`1` - Run event ends mid-trip<br /><br />Required if the run event ends with a mid-trip relief. Optional otherwise. Recommended to leave this field blank if `trip_id` is not set. |

#### `event_sequence`

`event_sequence` is required and unique within a run so it can be used in the Primary Key to uniquely identify events.

Note that events within a run may overlap in time. If they do, it may not be possible to define a single ordering that's correct for all uses. If a consumer cares about how overlapping events are ordered, they should sort based on the time fields and `event_type` instead.

In order to make the ordering of `event_sequence` more consistent if events overlap, it should follow these rules:

- If Event A and Event B are on the same `service_id` and `run_id`, and Event A has a `start_time` before Event B, then Event A's `event_sequence` should be less than Event B's.
- If Event A and B have the same `start_time`, but Event A has an `end_time` before Event B, then event A's `event_sequence` should be less than event B's.
- If Event A and B have the same `start_time` and `end_time`, then their `event_sequence` values can be in either order, but they must be different.

Values do not have to be consecutive.

#### `run_events` Notes

- Multiple `run_event`s can refer to the same `trip_id`, if multiple employees work on that trip.
- Events may have gaps between the end time of one event and the start time of the next. e.g. if an operator's layovers aren't represented by an event.
- Events may overlap in time, if an employee has multiple simultaneous responsibilities.
- `start_time` may equal `end_time` for an event that's a single point in time (such as a report time) without any duration.
- Recommended sort order: `service_id`, `run_id`, `event_sequence`.
