
# Reference

The Transit Operational Data Standard was last updated on February 27, 2024 (v2.0). View the full [revision history](./revision-history.md).


## Dataset Files

### Structure

There are two types of files used in the TODS standard:

- **`_supplement` files**, used to add, modify, and delete information from public GTFS files to model the operational service for internal purposes.
- **TODS-specific files**, used to model operational elements not currently defined in the GTFS standard.


### Files
  
| **File Name** | **Type** | **Description** |
| --- | --- | --- |
| trips_supplement.txt | Supplement | Supplements and modifies GTFS [trips.txt](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#tripstxt) with deadheads and other non-public trip information.|
| stops_supplement.txt | Supplement | Supplements and modifies GTFS [stops.txt](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#stopstxt) with internal stop locations, waypoints, and other non-public stop information.|
| stop_times_supplement.txt | Supplement | Supplements and modifies GTFS [stop_times.txt](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#stop_timestxt) with non-public times that trips stop at locations, and related information. |
| routes.txt | Supplement | Supplements and modifies GTFS [routes.txt](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#routestxt) with internal route identifiers and other non-public route identification. |
| runs_pieces.txt | TODS-Specific | Defines daily personnel schedules within a feed. |
| run_events.txt | TODS-Specific| Defines other scheduled activities to be performed by a member of personnel during a run. |

The use of the `_supplement` standard to modify other GTFS files remains experimental at this time.


## `_supplement` Files

### Structure & Evaluation

The fields in all `_supplement` files match those defined in the corresponding file's [GTFS specification](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md).

Each row in a `_supplement` file is used to modify the corresponding file in GTFS and should be evaluated as follows:

1. If the row's Primary Key is defined in the corresponding GTFS file, and the `TODS_delete` field is equal to `1`, remove the row from the GTFS file.
2. If the row's Primary Key is defined in the corresponding GTFS file, and the `TODS_delete` field is not defined or not equal to `1`, set or update (in the corresponding GTFS file) the value of any non-blank fields defined in the `_supplement` file's row to the `_supplement`'s value.
3. If the row's Primary key is NOT defined in the corresponding GTFS file, add the row to the corresponding GTFS file.

In other words, where a primary key matches, the row is either removed or any non-empty values in the row are used to *update* the corresponding GTFS values. Where a primary key match does not exist, the entire row is added.

### TODS-Specific Fields

In addition to the fields defined in GTFS, specific fields for use within TODS are denoted by a `TODS_` field prefix.

| **File** | **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- | --- |
| Any `_supplement` file | `TODS_delete` | Enum | Optional | (blank) - Update other fields; do not delete.<br>`1` - Deletes the GTFS row in the corresponding file whose primary key matches the value in the `_supplement` file's row. |
| `trips_supplement.txt` | `TODS_trip_type` | Text | Optional | Defines the type of the trip if distinct from a standard revenue trip. |
| `stops_supplement.txt` | `TODS_location_type` | Text | Optional | Defines the type of the location if distinct from a standard GTFS location type. Where defined, the GTFS `location_type` shall be ignored. |





## TODS-Specific File Definitions


### runs_pieces.txt

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| run_id | ID | Required | Identifies a run. |
| piece_id | ID | Required | Identifies the piece of the run. The piece_id field must be unique. |
| start_type | Enum | Required | Indicates whether the piece begins with a deadhead, a revenue trip, or an event.<br /><br />**0** - Deadhead <br />**1** - Trip <br />**2** - Event |
| start_trip_id | ID referencing **deadheads.deadhead_id** or [**trips.trip_id**](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#tripstxt) | Required | Identifies the deadhead or trip with which the piece begins. |
| start_trip_position | Non-negative Integer referencing **deadhead_times.location_sequence** or [**stop_times.stop_sequence**](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#stop_timestxt) | Optional | Identifies the first operational location or stop to be serviced in the first trip of the piece. This field should only be filled out if the piece does not begin at the first stop of the start trip. |
| end_type | Enum | Required | Indicates whether the piece ends with a deadhead, a revenue trip, or an event. <br /><br />**0** - Deadhead <br />**1** - Trip <br />**2** - Event |
| end_trip_id | ID referencing **deadheads.deadhead_id** or [**trips.trip_id**](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#tripstxt) | Required | Identifies the deadhead or trip with which the piece ends. |
| end_trip_position | Non-negative Integer referencing **deadhead_times.location_sequence** or [**stop_times.stop_sequence**](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#stop_timestxt) | Optional | Identifies the last operational location or stop to be serviced in the last trip of the piece. This field should only be filled out if the piece does not end at the last stop of the end trip. |

### run_events.txt

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| run_event_id | ID | Required | Identifies a run event. |
| piece_id | ID referencing **runs_pieces.piece_id** | Required | Identifies the piece during which the run event takes place. |
| event_type | Enum | Required | Indicates which event is scheduled in this entry.<br /><br />**0** - Report Time<br />**1** - Pre-Trip Activity<br />**2** - Post-Trip Activity<br />**3** - Fueling<br />**4** - Break<br />**5** - Availability<br />**6** - Activity<br />**7** - Other |
| event_name | String | Optional | The name for the event that is being used. |
| event_time | Time | Required | The time at which the event begins. |
| event_duration | Non-negative Integer | Required | The scheduled duration of the event from the event_time in seconds. |
| event_from_location_type | Enum | Optional | Indicates whether the event is scheduled to begin at an operational location or a stop.<br /><br />**0** - Operational Location<br />**1** - Stop |
| event_from_location_id | ID referencing **ops_locations.ops_location_id** or [**stops.stop_id**](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#stopstxt) | Optional | Identifies the operational location or stop at which the event is scheduled to begin. |
| event_to_location_type | Enum | Optional | Indicates whether the event is scheduled to end at an operational location or a stop.<br /><br />**0** - Operational Location<br />**1** - Stop |
| event_to_location_id | ID referencing **ops_locations.ops_location_id** or [**stops.stop_id**](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#stopstxt) | Optional | Identifies the operational location or stop at which the event is scheduled to end. |# Reference
