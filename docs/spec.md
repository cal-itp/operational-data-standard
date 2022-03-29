# Operational Data Standard

The Operational Data Standard (ODS) is an open standard for describing scheduled transit operations. ODS leverages the existing General Transit Feed Specification (GTFS) and extends it to include information about personnel and non-revenue service. These concepts, which are not included in the rider-oriented GTFS spec, are necessary for transit operators to be able to run a scheduled service.

## Overview

Transit providers need the systems they use to schedule and operate their service to be [interoperable](https://www.interoperablemobility.org/). Interoperability is best achieved through open standards. While GTFS is a very successful existing open standard, it is designed for giving information to transit riders, and, thus, is missing key concepts that are necessary for transit providers.

ODS is a proposal for a new open standard to define deadheads and runs. ODS is based on, and includes references to, GTFS-static files. ODS is proposed as a standard separate from GTFS in order to preserve the privacy of internal operations data.

ODS consists of a set of .txt files arranged into distinct modules. These modules identify the major new concepts supported within ODS that are not defined in GTFS. The two modules in ODS v1.0 are **Deadheads** and **Runs**.

## Deadheads

Deadheads are vehicle movements during which a transit vehicle is not in service. The Deadheads module of ODS contains three new files in addition to the files in GTFS. This module provides for the creation of scheduled deadheads tied to an existing GTFS feed and linked to significant locations (such as points where pull in, pull out, and layovers occur) in the service area.

| **File Name** | **Description** |
| --- | --- |
| deadheads.txt | Defines scheduled deadheads contained in a transit feed. (This file is analogous to [trips.txt](https://developers.google.com/transit/gtfs/reference#tripstxt) for non-revenue operations.) |
| ops_locations.txt | Significant operational locations relevant to the performance of vehicle deadheads. (This file is analogous to [stops.txt](https://developers.google.com/transit/gtfs/reference#stopstxt) for non-revenue operations.) |
| deadhead_times.txt | Times that a vehicle arrives at and departs from operational locations for each deadhead. (This file is analogous to [stop_times.txt](https://developers.google.com/transit/gtfs/reference#stop_timestxt) for non-revenue operations.) |

### deadheads.txt

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| deadhead_id | ID | Required | Identifies a deadhead. |
| service_id | ID referencing [**calendar.service_id**](https://developers.google.com/transit/gtfs/reference#calendartxt) | Required | Identifies a set of dates when the deadhead is scheduled to take place. |
| block_id | ID | Required | Identifies a set of dates when the deadhead is scheduled to take place. |
| shape_id | ID referencing [**shapes.shape_id**](https://developers.google.com/transit/gtfs/reference#shapestxt) | Optional | Identifies a geospatial shape that describes the vehicle travel path for a deadhead. |
| to_trip_id | ID referencing [**trips.trip_id**](https://developers.google.com/transit/gtfs/reference#tripstxt) | Conditionally Required | Identifies the trip scheduled immediately following to the deadhead within the block_id. |
| from_trip_id | ID referencing [**trips.trip_id**](https://developers.google.com/transit/gtfs/reference#tripstxt) | Conditionally Required | Identifies the trip scheduled immediately prior to the deadhead within the block_id. |
| to_deadhead_id | ID referencing **deadheads.deadhead_id** | Conditionally Required | Identifies the deadhead scheduled immediately following the deadhead within the block_id. |
| to_deadhead_id | ID referencing **deadheads.deadhead_id** | Conditionally Required | Identifies the deadhead scheduled immediately prior to the deadhead within the block_id. |

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
| ops_location_id | ID referencing **ops_locations.ops_location_id** | Required | Identifies the operational location specified by this record. |
| ops_location_sequence | Non-negative Integer | Required | Order of operational locations for a particular deadhead. The values must increase along the trip but do not need to be consecutive. |
| shape_dist_traveled | Non-negative Float | Optional | Actual distance traveled along the associated shape, from the first operational location to the operational location specified in this record. |

## Runs

Runs are representations of the daily work schedule for transit agency personnel. The Runs module of ODS contains three new files in addition to the files in GTFS and the Deadheads module. This module provides for the creation of scheduled runs tied to an existing GTFS feed and to the files from the Deadheads module.

| **File Name** | **Description** |
| --- | --- |
| runs.txt | Defines runs (personnel schedules) within a feed. |
| run_events.txt | Other scheduled activities to be performed by a member of personnel during a run. |
| event_alias.txt | Allows for values in the **run_events.event_name** field to be globally relabeled within a feed based on local terminology. |

### runs.txt

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| run_id | ID | Required | Identifies a run. |
| run_name | String | Required | The human readable name for the run. |
| piece_id | ID | Required | Identifies the piece of the run. |
| piece_name | String | Optional | The human-readable name for the piece. |
| start_type | Enum | Required | Indicates whether the piece begins with a deadhead, a revenue trip, or an event. <br /><br />**0** - Deadhead <br />**1** - Trip <br />**2** - Event |
| start_trip_id | ID referencing **deadheads.deadhead_id** or [**trips.trip_id**](https://developers.google.com/transit/gtfs/reference#tripstxt) | Required | Identifies the deadhead or trip with which the piece begins. |
| start_trip_position | Non-negative Integer referencing **deadhead_times.ops_location_sequence** or [**stop_times.stop_sequence**](https://developers.google.com/transit/gtfs/reference#stop_timestxt) | Optional | Identifies the first operational location or stop to be serviced in the first trip of the piece. This field should only be filled out if the piece does not begin at the first stop of the start trip. |
| end_type | Enum | Required | Indicates whether the piece ends with a deadhead, a revenue trip, or an event. <br /><br />**0** - Deadhead <br />**1** - Trip <br />**2** - Event |
| end_trip_id | ID referencing **deadheads.deadhead_id** or [**trips.trip_id**](https://developers.google.com/transit/gtfs/reference#tripstxt) | Required | Identifies the deadhead or trip with which the piece ends. |
| end_trip_position | Non-negative Integer referencing **deadhead_times.ops_location_sequence** or [**stop_times.stop_sequence**](https://developers.google.com/transit/gtfs/reference#stop_timestxt) | Optional | Identifies the last operational location or stop to be serviced in the last trip of the piece. This field should only be filled out if the piece does not end at the last stop of the end trip. |

### run_events.txt

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| run_event_id | ID | Required | Identifies a run event. |
| piece_id | ID referencing **runs.piece_id** | Required | Identifies the piece during which the run event takes place. |
| event_type | Enum | Required | Indicates which event is scheduled in this entry. <br />**0** - Report Time <br />**1** - Pre-Trip Activity <br />**2** - Post-Trip Activity <br />**3** - Fueling <br />**4** - Break <br />**5** - Availability <br />**6** - Activity <br />**7** - Other |
| event_time | Time | Required | The time at which the event begins. |
| event_duration | Non-negative Integer | Required | The scheduled duration of the event from the event_time in seconds. |
| event_location_type | Enum | Optional | Indicates whether the event is scheduled to occur at an operational location or a stop. <br /><br />**0** - Operational Location <br />**1** - Stop |
| event_location_id | ID referencing **ops_locations.ops_location_id** or [**stops.stop_id**](https://developers.google.com/transit/gtfs/reference#stopstxt) | Optional | Identifies the operational location or stop at which the event is scheduled to take place. |

### event_alias.txt

| **Field Name** | **Type** | **Required** | **Description** |
| --- | --- | --- | --- |
| event_name | Non-negative Integer | Required | The value of the event name which is to be renamed within the feed. |
| event_alias | String | Required | The name which is to be used in place of the standard event name within the feed. |
