# Examples

The following sections provide examples of how ODS can represent specific use cases. The inclusion of these examples should not
be as an indication that this is the only way to represent these use cases with ODS. If you have questions about a use case not
represented here, please feel free to [create an issue in GitHub](https://github.com/cal-itp/operational-data-standard/issues/new).

## Single Run with Pull-Out and Lunch Break

In this example, a bus driver is assigned to run 10000, which has four revenue trips on two pieces, all on the same block. The run also includes a pull-out, a pull-back, a pre-trip inspection, and a lunch break between the two pieces.

![Diagram showing four trips, two deadheads, and other events.](single-run-diagram.png)

### GTFS Files

These are the same files that would be published in the agency's public GTFS file, and contains only revenue trips and public information.

Some irrelevant files are ommitted for brevity.

#### `stops.txt`

```csv
stop_id,location_type
stop-1,0
stop-2,0
stop-3,0
```

#### `routes.txt`

```csv
route_id,route_short_name,route_type
12,12,3
```

#### `trips.txt`

```csv
route_id,service_id,trip_id,trip_headsign,direction_id,block_id
12,daily,101,North,0,BLOCK-A
12,daily,102,South,1,BLOCK-A
12,daily,103,North,0,BLOCK-A
12,daily,104,South,1,BLOCK-A
```

#### `stop_times.txt`

```csv
trip_id,arrival_time,stop_id,stop_sequence
101,10:00,stop-1,1
101,10:25,stop-2,2
101,10:50,stop-3,3
102,11:00,stop-3,1
102,11:25,stop-2,2
102,11:50,stop-1,3
103,13:00,stop-1,1
103,13:25,stop-2,2
103,13:50,stop-3,3
104,14:00,stop-3,1
104,14:25,stop-2,2
104,14:50,stop-1,3
```

### TODS Files

These are the new files that are published in TODS. In this example, the TODS files do not delete or modify any rows that were published in GTFS.

#### `stops_supplement.txt`

```csv
stop_id,location_type,TODS_location_type
garage,0,garage
garage-waypoint,0,
```

#### `routes_supplement.txt`

```csv
route_id,route_long_name
deadheads,Deadheads
```

In this example, the agency puts all of its deadheads on this new route, though agencies may have other ways to assign deadheads to routes.

#### `trips_supplement.txt`

```csv
route_id,service_id,trip_id,block_id,TODS_trip_type
deadheads,daily,deadhead-1,BLOCK-A,pull-out
deadheads,daily,deadhead-2,BLOCK-A,pull-back
```

In this example, consumers know that these trips aren't in revenue service because of the `route_id` and `TODS_trip_type`.

#### `stop_times_supplement.txt`

```csv
trip_id,arrival_time,stop_id,stop_sequence
deadhead-1,09:45:00,garage,1
deadhead-1,09:50:00,garage-waypoint,2
deadhead-1,09:55:00,stop-1,3
deadhead-2,14:50:00,stop-1,1
deadhead-2,14:55:00,garage-waypoint,2
deadhead-2,15:00:00,garage,3
```

#### `run_events.txt`

```csv
service_id,run_id,event_sequence,piece_id,block_id,job_type,event_type,trip_id,start_location,start_time,start_mid_trip,end_location,end_time,end_mid_trip
daily,10000,10,       ,       ,Operator,Report Time,        ,garage,09:30:00,,garage,09:30:00,
daily,10000,20,       ,       ,Operator,Pre-Trip Inspection,,garage,09:35:00,,garage,09:45:00,
daily,10000,30,10000-1,BLOCK-A,Operator,Pull-Out,deadhead-1 ,garage,09:45:00,2,stop-1,09:55:00,2
daily,10000,40,10000-1,BLOCK-A,Operator,Operator,101        ,stop-1,10:00:00,2,stop-3,10:50:00,2
daily,10000,50,10000-1,BLOCK-A,Operator,Operator,102        ,stop-3,11:00:00,2,stop-1,11:50:00,2
daily,10000,60,       ,       ,Operator,Break,              ,stop-1,11:50:00,,stop-1,13:00:00,
daily,10000,70,10000-2,BLOCK-A,Operator,Operator,103        ,stop-1,13:00:00,2,stop-3,13:50:00,2
daily,10000,80,10000-2,BLOCK-A,Operator,Operator,104        ,stop-3,14:00:00,2,stop-1,14:50:00,2
daily,10000,90,10000-2,BLOCK-A,Operator,Pull-Back,deadhead-2,stop-1,14:50:00,2,garage,15:00:00,2
```

## Multiple Runs on a Single Block with Mid-Trip Relief

In this example, the bus driver assigned to run 10000 pulls out a bus, does trip 101 and part of trip 102, and then ends their day at `stop-2`. A new driver on run 20000 boards the bus, completes trip 102, then does trip 103 and trip 104, and pulls back to the garage.

![Diagram showing four trips, with the second trip broken into two different assignments.](mid-trip-relief-diagram.png)

This example uses the [exact same GTFS files as the previous example](#gtfs-files). Deadheads and nonrevenue locations are omitted in order to focus on the revenue trip assignments, so no `_supplement.txt` files are needed for this example. Only `run_events.txt` needs to change to reflect the multiple runs and mid-trip relief.

### `run_events.txt`

```csv
service_id,run_id,event_sequence,piece_id,block_id,job_type,event_type,trip_id,start_location,start_time,start_mid_trip,end_location,end_time,end_mid_trip
daily,10000,10,10000-1,BLOCK-A,Operator,Operator,101,stop-1,10:00:00,2,stop-3,10:50:00,2
daily,10000,20,10000-1,BLOCK-A,Operator,Operator,102,stop-3,11:00:00,2,stop-2,11:25:00,1
daily,20000,10,20000-1,BLOCK-A,Operator,Operator,102,stop-2,11:25:00,1,stop-1,11:50:00,2
daily,20000,20,20000-1,BLOCK-A,Operator,Operator,103,stop-1,13:00:00,2,stop-3,13:50:00,2
daily,20000,30,20000-1,BLOCK-A,Operator,Operator,104,stop-3,14:00:00,2,stop-1,14:50:00,2
```

## Multiple operators on the same trip

In this example (unrelated to the previous examples), a two-car train does a round trip, and requires two operators, one in the first car and one in the second car. The `event_type` field distinguishes whether an operator is in the front car or the rear car. The operators swap for the return trip.

### `run_events.txt`

```csv
service_id,run_id,event_sequence,job_type,event_type,trip_id,start_location,start_time,end_location,end_time
weekday,10000,10,Operator,Operate 1st Car,trip-1,stop-1,10:00:00,stop-2,10:58:00
weekday,10000,20,Operator,Operate 2nd Car,trip-2,stop-2,11:00:00,stop-1,11:58:00
weekday,20000,10,Operator,Operate 2nd Car,trip-1,stop-1,10:00:00,stop-2,10:58:00
weekday,20000,20,Operator,Operate 1st Car,trip-2,stop-2,11:00:00,stop-1,11:58:00
```

## Run as Directed work

In this example (unrelated to the previous examples), an operator signs in for their shift, pulls out, and then operates a bus for several hours. They are not scheduled to do specific trips, but instead do trips as directed to by dispatch. This approach could apply in several situations:

- An agency uses `frequencies.txt` (`frequencies.trip_id` may be able to be referenced in `run_events.trip_id`).
- An agency publishes specific times in GTFS `trips.txt`, but in practice operates the service according to a headway, or doesn't schedule operators to specific trips.
- The operator is assigned to cover or strategic work, and is positioned somewhere where they can cover absences or gaps in service on any route throughout the day.

### `run_events.txt`

```csv
service_id,run_id,event_sequence,block_id,event_type,trip_id,start_location,start_time,end_location,end_time
weekday,10000,10,       ,sign-in        ,,garage,08:45:00,garage,08:50:00
weekday,10000,20,BLOCK-A,deadhead       ,,garage,08:50:00,stop-1,09:00:00
weekday,10000,30,BLOCK-A,run-as-directed,,stop-1,09:00:00,stop-1,12:00:00
weekday,10000,30,BLOCK-A,deadhead       ,,stop-1,12:00:00,garage,12:10:00
```

## Distinct Crew and Trip schedule scenarios

The below examples identify how to use the distinct `trip_service_id` feature of `run_events.txt` to model instances in which crew schedules may be decoupled from trips, forming a many:1 relationship of runs and trips.


### Extra staffing for a special event

Due to a baseball game, an additional ticket collector will be assigned to supplement the existing crew on train 101, serving the ballpark.

#### `run_events.txt`

_Note that the `run_id` of 1 maps to the combination of `(service_id, trip_service_id)`, meaning other runs with the same `run_id` of `1` can be in effect at the same time provided they existin other combinations of `(service_id, trip_service_id)`._

```csv
service_id,trip_service_id,run_id,event_sequence,event_type,trip_id,start_location,start_time,end_location,end_time
gameday,weekday,1,1,signup,,main_terminal,14:00:00,main_terminal,14:15:00
gameday,weekday,1,2,collector,train_101,main_terminal,14:45:00,ballpark,15:30:00
gameday,weekday,1,3,work_as_directed,train_101,ballpark,15:30:00,main_terminal,22:00:00
gameday,weekday,1,4,signoff,,main_terminal,22:00:00,main_terminal,22:15:00
```

#### `calendar_dates_supplement.txt`

The added position can be added on the applicable gamedays via `calendar_dates_supplement.txt`.

```csv
service_id,date,exception_type
gameday,20240820,1
gameday,20240821,1
gameday,20240827,1
gameday,20240903,1
```


### Different runs mapping to the same set of trips

Consider a bus network between West City, Eastland, and Northingdon. Route 1 runs between West City and Eastland via Northingdon, whereas Route 2 runs directly between the two cities.

To improve on-time performance, the driver working the 10:45am Route 1 departure and the driver of the 11am Route 2 departure will exchange these trips effective September 2024.

#### `trips.txt`

```csv
route_id,service_id,trip_id,trip_headsign,direction_id
1,weekday,10001,Eastland via Northingdon,1
2,weekday,20001,Eastland,1
1,weekday,10002,West City via Northingdon,0
2,weekday,20002,West City,0
```

#### `calendar.txt`

Assume these trips run daily on weekdays in the defined date range.

```csv
service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date
weekday,1,1,1,1,1,0,0,20240101,20241231
```

#### `run_events.txt`

The current runs can be modeled with service_id `current`, and mapped to the existing `weekday` trips. The future runs can be modeled with service_id `future`, also mapped to the existing `weekday` trips. The service_id `weekday` is already defined in `calendar.txt`, but neither `current` nor `future` are.

```csv
service_id ,trip_service_id ,run_id ,event_sequence ,block_id ,event_type ,trip_id ,start_location ,start_time ,end_location ,end_time
current ,weekday ,1 ,10 ,A ,report  ,      ,garage   ,08:00:00 ,garage   ,08:20:00
current ,weekday ,1 ,20 ,A ,drive   ,10001 ,westcity ,09:00:00 ,eastland ,10:30:00
current ,weekday ,1 ,30 ,A ,drive   ,10002 ,eastland ,10:45:00 ,westcity ,12:15:00
current ,weekday ,1 ,40 ,A ,signoff ,      ,garage   ,12:45:00 ,garage   ,13:00:00

current ,weekday ,2 ,10 ,B ,report  ,      ,garage   ,08:00:00 ,garage   ,08:20:00
current ,weekday ,2 ,20 ,B ,drive   ,20001 ,westcity ,09:00:00 ,eastland ,10:00:00
current ,weekday ,2 ,30 ,B ,drive   ,20002 ,eastland ,11:00:00 ,westcity ,12:00:00
current ,weekday ,2 ,40 ,B ,signoff ,      ,garage   ,12:30:00 ,garage   ,12:45:00

future  ,weekday ,1 ,10 ,A ,report  ,      ,garage   ,08:00:00 ,garage   ,08:20:00
future  ,weekday ,1 ,20 ,A ,drive   ,10001 ,westcity ,09:00:00 ,eastland ,10:30:00
future  ,weekday ,1 ,30 ,A ,drive   ,20002 ,eastland ,11:00:00 ,westcity ,12:00:00
future  ,weekday ,1 ,40 ,A ,signoff ,      ,garage   ,12:30:00 ,garage   ,12:45:00

future  ,weekday ,2 ,10 ,B ,report  ,      ,garage   ,08:00:00 ,garage   ,08:20:00
future  ,weekday ,2 ,20 ,B ,drive   ,20001 ,westcity ,09:00:00 ,eastland ,10:00:00
future  ,weekday ,2 ,30 ,B ,drive   ,10002 ,eastland ,10:45:00 ,westcity ,12:15:00
future  ,weekday ,2 ,40 ,B ,signoff ,      ,garage   ,12:45:00 ,garage   ,13:00:00
```

#### `calendar_supplement.txt`

To detail the presence of the new `service_id`s and assign them to their applicable days of the week, the runs can be added to the calendar via `calendar_supplement.txt`:

```csv
service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date
current,1,1,1,1,1,0,0,20240101,20240831
future ,1,1,1,1,1,0,0,20240901,20241231
```

### Variations of runs by day of the week

Consider a commuter train line that operates three daily round-trips: two morning inbound trains from the suburbs to the city, two evening return trips from the city to the suburbs, plus one reverse-peak trip for day-trippers to the outlying village and back.

Every day, the same six trips are operated from the public perspective, with the crew of the earlier morning inbound rush-hour trip always working the earlier evening outbound rush-hour trip (trains 102 and 101, respectively), and the other crew working the later of the two (trains 104 and 103, respectively). To more evenly distribute fatigue and rest, the midday round-trip (trains 191 and 192) is split between the early and late crews by day-of-week, and switching halfway through the year. Whichever crew works the midday trip takes their break in the suburban village, whereas the other crew takes their break in the city.


#### `trips.txt`

Rather than listing these trips as varying by day-of-week in a public-facing schedule, these can indeed be maintained as a single service_id in `trips.txt`.

```csv
route_id,service_id,trip_id,trip_headsign,direction_id,trip_short_name
commuter_line,spring_train_schedule,spring-city_train_102,City   ,1,102
commuter_line,spring_train_schedule,spring-city_train_104,City   ,1,104
commuter_line,spring_train_schedule,spring-city_train_191,Suburbs,0,191
commuter_line,spring_train_schedule,spring-city_train_192,City   ,1,192
commuter_line,spring_train_schedule,spring-city_train_101,Suburbs,0,101
commuter_line,spring_train_schedule,spring-city_train_103,Suburbs,0,103
```

#### `calendar.txt`

Assume these trips run daily on weekdays in the defined date range.

```csv
service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date
spring_train_schedule,1,1,1,1,1,0,0,20240101,20241231
```

#### `run_events.txt`

The individual runs can be broken into two run-based service_ids: `spring_train_latelong` represents the days where the late job works the midday trip (and has its break in the village), whereas `spring_train_earlylong` represents the days where the early job works the midday trip.

Note that in all circumstances, the trips all reference those with `service_id` matching `spring_train_schedule`; there are not any trips defined under `service_id` `spring_train_latelong` nor `spring_train_earlylong`.

```csv
service_id,trip_service_id,run_id,event_sequence,block_id,event_type,trip_id,start_location,start_time,end_location,end_time

spring_train_latelong ,spring_train_schedule,early_job,10,BLOCK-A,sign-in  ,                     ,yard   ,06:00:00,yard   ,06:15:00
spring_train_latelong ,spring_train_schedule,early_job,20,BLOCK-A,conductor,spring-city_train_102,village,06:30:00,city   ,07:30:00
spring_train_latelong ,spring_train_schedule,early_job,30,BLOCK-A,release  ,                     ,city   ,07:45:00,city   ,16:00:00
spring_train_latelong ,spring_train_schedule,early_job,40,BLOCK-A,conductor,spring-city_train_101,city   ,16:30:00,village,17:30:00
spring_train_latelong ,spring_train_schedule,early_job,50,BLOCK-A,sign-off ,                     ,yard   ,17:30:00,yard   ,17:45:00

spring_train_latelong ,spring_train_schedule,later_job,10,BLOCK-B,sign-in  ,                     ,yard   ,07:00:00,yard   ,07:15:00
spring_train_latelong ,spring_train_schedule,later_job,20,BLOCK-B,conductor,spring-city_train_104,village,07:30:00,city   ,08:30:00
spring_train_latelong ,spring_train_schedule,later_job,30,BLOCK-B,conductor,spring-city_train_191,city   ,09:00:00,village,10:00:00
spring_train_latelong ,spring_train_schedule,later_job,40,BLOCK-B,break    ,                     ,village,10:00:00,village,15:00:00
spring_train_latelong ,spring_train_schedule,later_job,50,BLOCK-B,conductor,spring-city_train_190,village,15:00:00,city   ,16:00:00
spring_train_latelong ,spring_train_schedule,later_job,60,BLOCK-B,conductor,spring-city_train_103,city   ,17:30:00,village,18:30:00
spring_train_latelong ,spring_train_schedule,later_job,70,BLOCK-B,sign-off ,                     ,yard   ,18:30:00,yard   ,18:45:00

spring_train_earlylong,spring_train_schedule,early_job,10,BLOCK-A,sign-in  ,                     ,yard   ,06:00:00,yard   ,06:15:00
spring_train_earlylong,spring_train_schedule,early_job,20,BLOCK-A,conductor,spring-city_train_102,village,06:30:00,city   ,07:30:00
spring_train_earlylong,spring_train_schedule,early_job,30,BLOCK-A,conductor,spring-city_train_191,city   ,09:00:00,village,10:00:00
spring_train_earlylong,spring_train_schedule,early_job,40,BLOCK-A,break    ,                     ,village,10:00:00,village,15:00:00
spring_train_earlylong,spring_train_schedule,early_job,50,BLOCK-A,conductor,spring-city_train_190,village,15:00:00,city   ,16:00:00
spring_train_earlylong,spring_train_schedule,early_job,60,BLOCK-A,conductor,spring-city_train_101,city   ,16:30:00,village,17:30:00
spring_train_earlylong,spring_train_schedule,early_job,70,BLOCK-A,sign-off ,                     ,yard   ,17:30:00,yard   ,17:45:00

spring_train_earlylong,spring_train_schedule,later_job,10,BLOCK-B,sign-in  ,                     ,yard   ,07:00:00,yard   ,07:15:00
spring_train_earlylong,spring_train_schedule,later_job,20,BLOCK-B,conductor,spring-city_train_104,village,07:30:00,city   ,08:30:00
spring_train_earlylong,spring_train_schedule,later_job,30,BLOCK-B,release  ,                     ,city   ,08:45:00,city   ,17:00:00
spring_train_earlylong,spring_train_schedule,later_job,40,BLOCK-B,conductor,spring-city_train_103,city   ,17:30:00,village,18:30:00
spring_train_earlylong,spring_train_schedule,later_job,50,BLOCK-B,sign-off ,                     ,yard   ,18:30:00,yard   ,18:45:00

```

#### `calendar_supplement.txt`

To detail the presence of the new `service_id`s and assign them to their applicable days of the week, the runs can be added to the calendar via `calendar_supplement.txt`:

```csv
service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date
spring_train_latelong ,1,0,1,0,1,0,0,20240101,20240630
spring_train_earlylong,0,1,0,1,0,0,0,20240101,20240630
spring_train_earlylong,1,0,1,0,1,0,0,20240701,20241231
spring_train_latelong ,0,1,0,1,0,0,0,20240701,20241231
```

### Jobs of entirely nonrevenue operations

A special track inspection train is being operated on a particular day, supported by an extra crew position.

_Note: The deadhead trips themselves could be defined in their own new `service_id` even without definining corresponding run data in `run_events.txt` using the `calendar_supplement.txt` or `calendar_dates_supplement.txt` files._


#### `trips_supplement.txt`

```csv
route_id,service_id,trip_id,TODS_trip_type,direction_id
line1,inspection_train,inspection_line1_ob,deadhead,0
line1,inspection_train,inspection_line1_ib,deadhead,1
line1,inspection_train,inspection_line2_ob,deadhead,0
line1,inspection_train,inspection_line2_ib,deadhead,1
line1,inspection_train,inspection_line3_ob,deadhead,0
line1,inspection_train,inspection_line3_ib,deadhead,1
```

#### `stop_times_supplement.txt`

```csv
trip_id,arrival_time,stop_id
inspection_line1_ob,downtown,08:00:00
inspection_line1_ob,anytown,09:00:00
inspection_line1_ib,anytown,09:15:00
inspection_line1_ib,downtown,10:15:00
inspection_line2_ob,downtown,11:00:00
inspection_line2_ob,busyville,12:30:00
inspection_line2_ib,busyville,13:00:00
inspection_line2_ib,downtown,14:30:00
inspection_line3_ob,downtown,15:00:00
inspection_line3_ob,centerton,15:45:00
inspection_line3_ib,centerton,16:00:00
inspection_line3_ib,downtown,16:45:00
```


#### `calendar_dates_supplement.txt`

```csv
service_id,date,exception_type
inspection_train,20240901
```


#### `run_events.txt`

Here a run can be defined alongside entirely deadhead trips added via `trips_supplement.txt` using the same `service_id` defined and assigned in `calendar_dates_supplement.txt`.

```csv
service_id,run_id,event_sequence,event_type,trip_id,start_location,start_time,end_location,end_time
inspection_train ,1 ,1 ,signup   ,                    ,main_terminal ,07:15:00 ,main_terminal ,07:45:00
inspection_train ,1 ,2 ,operator ,inspection_line1_ob ,downtown      ,08:00:00 ,anytown       ,09:00:00
inspection_train ,1 ,3 ,operator ,inspection_line1_ib ,anytown       ,09:15:00 ,downtown      ,10:15:00
inspection_train ,1 ,4 ,operator ,inspection_line2_ob ,downtown      ,11:00:00 ,busyville     ,12:30:00
inspection_train ,1 ,5 ,operator ,inspection_line2_ib ,busyville     ,13:00:00 ,downtown      ,14:30:00
inspection_train ,1 ,6 ,operator ,inspection_line3_ob ,downtown      ,15:00:00 ,centerton     ,15:45:00
inspection_train ,1 ,7 ,operator ,inspection_line3_ib ,centerton     ,16:00:00 ,downtown      ,16:45:00
gameday          ,1 ,8 ,signoff  ,                    ,main_terminal ,17:00:00 ,main_terminal ,17:30:00

```

### Activating a storm schedule

Assume a public GTFS file includes a set of trips with service_id `storm_schedule`, with no normal assignment in the calendar.

#### `calendar.txt`

```csv
service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date
normal,1,1,1,1,1,0,0,20240101,20241231
storm_schedule,0,0,0,0,0,0,0,20240101,20241231
```

#### `calendar_dates.txt`

This storm schedule could be activated whenever inclement weather is encountered by updating `calendar_dates.txt` to include:

```csv
service_id,date,exception_type
normal,20240901,2
storm_schedule,20240901,1
```

#### `calendar_dates_supplement.txt`

While waiting for the GTFS data to propagate through one's system, this could also be reflected in the TODS `calendar_dates_supplement.txt` file to activate the change in any operational systems, alongside any runs associated with the `storm_schedule` service_id.

```csv
service_id,date,exception_type
normal,20240901,2
storm_schedule,20240901,1
```
