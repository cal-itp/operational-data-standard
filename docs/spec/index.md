# Reference

The Operational Data Standard was last updated on April 14, 2022 (v1.0). View the full [revision history](./revision-history.md).

## Dataset Files

| **File Name** | **Description** |
| --- | --- |
| deadheads.txt | Defines scheduled deadheads contained in a transit feed. (This file is analogous to [trips.txt](https://developers.google.com/transit/gtfs/reference#tripstxt) for non-revenue operations.) |
| ops_locations.txt | Significant operational locations relevant to the performance of vehicle deadheads. (This file is analogous to [stops.txt](https://developers.google.com/transit/gtfs/reference#stopstxt) for non-revenue operations.) |
| deadhead_times.txt | Times that a vehicle arrives at and departs from operational locations for each deadhead. (This file is analogous to [stop_times.txt](https://developers.google.com/transit/gtfs/reference#stop_timestxt) for non-revenue operations.) |
| runs_pieces.txt | Defines daily personnel schedules within a feed. |
| run_events.txt | Defines other scheduled activities to be performed by a member of personnel during a run. |

## Field Definitions

### deadheads.txt

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| deadhead_id | ID | Required | Identifies a deadhead. |
| service_id | ID referencing [**calendar.service_id**](https://developers.google.com/transit/gtfs/reference#calendartxt) | Required | Identifies a set of dates when the deadhead is scheduled to take place. |
| block_id | ID | Required | Identifies the block to which the deadhead belongs. |
| shape_id | ID referencing [**shapes.shape_id**](https://developers.google.com/transit/gtfs/reference#shapestxt) | Optional | Identifies a geospatial shape that describes the vehicle travel path for a deadhead. |
| to_trip_id | ID referencing [**trips.trip_id**](https://developers.google.com/transit/gtfs/reference#tripstxt) | Conditionally Required | Identifies the trip scheduled immediately following to the deadhead within the block_id. |
| from_trip_id | ID referencing [**trips.trip_id**](https://developers.google.com/transit/gtfs/reference#tripstxt) | Conditionally Required | Identifies the trip scheduled immediately prior to the deadhead within the block_id. |
| to_deadhead_id | ID referencing **deadheads.deadhead_id** | Conditionally Required | Identifies the deadhead scheduled immediately following the deadhead within the block_id. |
| from_deadhead_id | ID referencing **deadheads.deadhead_id** | Conditionally Required | Identifies the deadhead scheduled immediately prior to the deadhead within the block_id. |

### ops_locations.txt

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| ops_location_id | ID | Required | Identifies an operational location. |
| ops_location_code | String | Optional | Short text or a number that identifies the operational location for internal use. |
| ops_location_name | String | Required | Name of the operational location. |
| ops_location_desc | String | Optional | Description of the operational location. |
| ops_location_lat | Latitude | Required | The latitude of the operational location. |
| ops_location_lon | Longitude | Required | The longitude of the operational location. |

### deadhead_times.txt

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| deadhead_id | ID referencing **deadheads.deadhead_id** | Required | Identifies a deadhead. |
| arrival_time | Time | Required | The time at which the vehicle is scheduled to arrive at the operational location specified by this record. |
| departure_time | Time | Required | The time at which the vehicle is scheduled to depart from the operational location specified by this record. |
| ops_location_id | ID referencing **ops_locations.ops_location_id** | Conditionally Required | Identifies the operational location specified by this record.<br /><br />If stop_id is blank, ops_location_id is required. If stop_id is not blank, ops_location_id must be blank. |
| stop_id | ID referencing **[stops.stop_id](https://developers.google.com/transit/gtfs/reference#stopstxt)** | Conditionally Required | Identifies the stop specified by this record.<br /><br />If ops_location_id is blank, stop_id is required. If ops_location_id is not blank, stop_id must be blank. |
| location_sequence | Non-negative Integer | Required | Order of locations, including both operational locations and stops, for a particular deadhead. The values must increase along the trip but do not need to be consecutive. |
| shape_dist_traveled | Non-negative Float | Optional | Actual distance traveled along the associated shape, from the first location to the location specified in this record. |

### runs_pieces.txt

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| run_id | ID | Required | Identifies a run. |
| piece_id | ID | Required | Identifies the piece of the run. The piece_id field must be unique. |
| start_type | Enum | Required | Indicates whether the piece begins with a deadhead, a revenue trip, or an event.<br /><br />**0** - Deadhead <br />**1** - Trip <br />**2** - Event |
| start_trip_id | ID referencing **deadheads.deadhead_id** or [**trips.trip_id**](https://developers.google.com/transit/gtfs/reference#tripstxt) | Required | Identifies the deadhead or trip with which the piece begins. |
| start_trip_position | Non-negative Integer referencing **deadhead_times.location_sequence** or [**stop_times.stop_sequence**](https://developers.google.com/transit/gtfs/reference#stop_timestxt) | Optional | Identifies the first operational location or stop to be serviced in the first trip of the piece. This field should only be filled out if the piece does not begin at the first stop of the start trip. |
| end_type | Enum | Required | Indicates whether the piece ends with a deadhead, a revenue trip, or an event. <br /><br />**0** - Deadhead <br />**1** - Trip <br />**2** - Event |
| end_trip_id | ID referencing **deadheads.deadhead_id** or [**trips.trip_id**](https://developers.google.com/transit/gtfs/reference#tripstxt) | Required | Identifies the deadhead or trip with which the piece ends. |
| end_trip_position | Non-negative Integer referencing **deadhead_times.location_sequence** or [**stop_times.stop_sequence**](https://developers.google.com/transit/gtfs/reference#stop_timestxt) | Optional | Identifies the last operational location or stop to be serviced in the last trip of the piece. This field should only be filled out if the piece does not end at the last stop of the end trip. |

### run_events.txt

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| run_event_id | ID | Required | Identifies a run event. |
| piece_id | ID referencing **runs_pieces.piece_id** | Required | Identifies the piece during which the run event takes place. |
| event_type | Enum | Required | Indicates which event is scheduled in this entry.<br /><br />**0** - Report Time<br />**1** - Pre-Trip Activity<br />**2** - Post-Trip Activity<br />**3** - Fueling<br />**4** - Break<br />**5** - Availability<br />**6** - Activity<br />**7** - Other |
| event_name | String | Optional | The name for the event that is being used. |
| start_time | Time | Required | The time at which the event begins. |
| end_time | Time | Required | The time at which the event ends. |
| duration_type | Enum | Required | Indicates whether the piece begins with a deadhead, a revenue trip, or an event.<br /><br />**0** - End on Time <br />**1** - Fixed Duration <br />**2** - Minimum Duration |
| minimum_duration | Time | Conditionally Required | The shortest duration, in seconds, that should be allotted for an event if the event does not begin early enough to end on time. This field is required for events with a duration_type of 2. |
| event_from_location_type | Enum | Optional | Indicates whether the event is scheduled to begin at an operational location or a stop.<br /><br />**0** - Operational Location<br />**1** - Stop |
| event_from_location_id | ID referencing **ops_locations.ops_location_id** or [**stops.stop_id**](https://developers.google.com/transit/gtfs/reference#stopstxt) | Optional | Identifies the operational location or stop at which the event is scheduled to begin. |
| event_to_location_type | Enum | Optional | Indicates whether the event is scheduled to end at an operational location or a stop.<br /><br />**0** - Operational Location<br />**1** - Stop |
| event_to_location_id | ID referencing **ops_locations.ops_location_id** or [**stops.stop_id**](https://developers.google.com/transit/gtfs/reference#stopstxt) | Optional | Identifies the operational location or stop at which the event is scheduled to end. |
