# Pretripping and Pull-Out

In this example, bus driver X is assigned to block A, run 10000 and piece 10000-1. The driver reports to the yard at 5:50 a.m. and begins pre-trip inspection at 6:07 a.m. before pulling out of the yard for trip 101 at 6:20 a.m. The driver is scheduled to arrive at the first stop of trip 101 at 6:28 a.m. and depart at 6:30 a.m.

## Data

### [`trips.txt`](trips.txt)

```csv
route_id,service_id,trip_id,trip_headsign,trip_short_name,direction_id,block_id,shape_id,wheelchair_accessible,bikes_allowed
12,daily,101,,,0,BLOCK-A,,,,
```

### [`calendar.txt`](calendar.txt)

```csv
service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date
daily,1,1,1,1,1,1,1,01012022,12312022
```

### [`stop_times.txt`](stop_times.txt)

```csv
trip_id,arrival_time,departure_time,stop_id,stop_sequence,stop_headsign,pickup_type,drop_off_type,continuous_pickup,continuous_drop_off,shape_dist_traveled,timepoint
101,06:28:00,06:30:00,5490,0,,,,,,
101,06:40:00,06:40:00,5491,1,,,,,,
101,06:50:00,06:50:00,5492,2,,,,,,
101,07:00:00,07:00:00,5493,3,,,,,,
```

### [`deadheads.txt`](deadheads.txt)

```csv
deadhead_id,service_id,block_id,shape_id,to_trip_id,from_trip_id,to_deadhead_id,from_deadhead_id
daily-deadhead-1,daily,BLOCK-A,,101,,,
```

### [`deadhead_times.txt`](deadhead_times.txt)

```csv
deadhead_id,arrival_time,departure_time,ops_location_id,stop_id,location_sequence,shape_dist_traveled
daily-deadhead-1,06:15:00,06:15:00,yard,,0,
daily-deadhead-1,06:20:00,06:20:00,pull-out-point,,1,
daily-deadhead-1,06:28:00,06:28:00,,8500,4,
```

### [`ops_locations.txt`](ops_locations.txt)

```csv
ops_location_id,ops_location_code,ops_location_name,ops_location_desc,ops_location_lat,ops_location_lon
yard,,"Main Yard",,34.000,-115.00
pull-out-point,,"Yard Pull Out",,34.000,-115.00
```

### [`runs_pieces.txt`](run_pieces.txt)

```csv
run_id,piece_id,start_type,start_trip_id,start_trip_position,end_type,end_trip_id,end_trip_position
10000,10000-1,0,daily-deadhead-1,,1,101,
```

### [`run_events.txt`](run_events.txt)

```csv
run_event_id,piece_id,event_type,event_name,event_time,event_duration,event_to_location_type,event_to_location_id,event_from_location_type,event_from_location_id
af0d9802,10000-1,0,,05:50:00,0,0,yard,0,yard
ebc02834,10000-1,1,"pre-trip inspection",06:07:00,600,0,yard,0,yard
1f4da873,10000-1,7,"pull-out from yard",06:20:00,0,0,pull-out-point,0,pull-out-point
```
