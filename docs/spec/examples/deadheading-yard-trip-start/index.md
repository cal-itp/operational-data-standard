# Deadheading from yard to start of trip

![Diagram depicting deadheading from a yard to the start of a trip](diagram.png)

## Data

### [`stops.txt`](stops.txt)

```csv
stop_id,stop_code,stop_name,stop_desc,stop_lat,stop_lon,zone_id,stop_url,location_type,parent_station,stop_timezone,wheelchair_boarding,level_id,platform_code
8500,8500,"First Stop",,33.000,-153.000,,,,,,,,,
8501,8501,"Second Stop",,33.000,-153.000,,,,,,,,,
8502,8502,"Third Stop",,33.000,-153.000,,,,,,,,,
8503,8503,"Fourth Stop",,33.000,-153.000,,,,,,,,,
8504,8504,"Fifth Stop",,33.000,-153.000,,,,,,,,,
8505,8505,"Sixth Stop",,33.000,-153.000,,,,,,,,,
8506,8506,"Seventh Stop",,33.000,-153.000,,,,,,,,,
8507,8507,"Eighth Stop",,33.000,-153.000,,,,,,,,,
```

### [`stop_times.txt`](stop_times.txt)

```csv
trip_id,arrival_time,departure_time,stop_id,stop_sequence,stop_headsign,pickup_type,drop_off_type,continuous_pickup,continuous_drop_off,shape_dist_traveled,timepoint
101,10:00:00,10:01:00,8500,1,,,,,,
101,10:10:00,10:11:00,8501,2,,,,,,
101,10:20:00,10:21:00,5492,3,,,,,,
101,10:30:00,10:31:00,5493,4,,,,,,
101,10:40:00,10:41:00,5494,5,,,,,,
101,10:50:00,10:51:00,5495,6,,,,,,
101,11:00:00,11:01:00,5496,7,,,,,,
101,11:10:00,11:11:00,5497,8,,,,,,
```

### [`deadheads.txt`](deadheads.txt)

```csv
deadhead_id,service_id,block_id,shape_id,to_trip_id,from_trip_id,to_deadhead_id,from_deadhead_id
test-deadhead,daily,BLOCK-A,,101,,,
```

### [`deadhead_times.txt`](deadhead_times.txt)

```csv
deadhead_id,arrival_time,departure_time,ops_location_id,stop_id,location_sequence,shape_dist_traveled
test-deadhead,09:45:00,09:45:00,yard,,0,
test-deadhead,09:46:00,09:46:00,yard-pull-out,,1,
test-deadhead,09:50:00,09:50:00,,8506,2,
test-deadhead,09:55:00,09:55:00,,8507,3,
test-deadhead,10:00:00,10:00:00,,8500,4,
```

### [`ops_locations.txt`](ops_locations.txt)

```csv
ops_location_id,ops_location_code,ops_location_name,ops_location_desc,ops_location_lat,ops_location_lon
yard,,"Main Yard",,34.000,-115.00
yard-pull-out,,"Yard Pull Out",,34.000,-115.00
```
