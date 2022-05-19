# Multiple Runs on a Single Block (With Mid-Trip Relief)

In this example, bus driver X is assigned to run 10000 and completes trip 101 and part of trip 102. Bus driver Y is assigned to run 20000 and completes the remainder of trip 102, before proceeding to trips 103 and 104. The trips serve route 12 and are part of block BLOCK-A. Driver X begins their day at a bus yard prior to trip 101 and driver Y returns to the same bus yard following trip 104.

![multiple-runs-one-block-midtrip-relief](diagram.png)

## Characteristics

* Run 10000 and run 20000 are not subdivided into multiple pieces.
* Run 10000 ends before the last scheduled stop of a trip (a driver is relieved mid-trip).
* Run 20000 begins after the first scheduled stop of a trip (the driver is relieving someone mid-trip).

## Data

### `trips.txt`

```csv
route_id,service_id,trip_id,trip_headsign,trip_short_name,direction_id,block_id,shape_id,wheelchair_accessible,bikes_allowed
12,daily,101,,,0,BLOCK-A,,,,
12,daily,102,,,1,BLOCK-A,,,,
12,daily,103,,,0,BLOCK-A,,,,
12,daily,104,,,1,BLOCK-A,,,,
```

### `calendar.txt`

```csv
service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date
daily,1,1,1,1,1,1,1,01012022,12312022
```

### `deadheads.txt`

```csv
deadhead_id,service_id,block_id,shape_id,to_trip_id,from_trip_id,to_deadhead_id,from_deadhead_id
daily-deadhead-1,daily,BLOCK-A,,101,,,
daily-deadhead-2,daily,BLOCK-A,,,104,,
```

### `runs_pieces.txt`

```csv
run_id,piece_id,start_type,start_trip_id,start_trip_position,end_type,end_trip_id,end_trip_position
10000,10000-1,0,daily-deadhead-1,,1,102,mid_relief_stop
20000,20000-1,1,103,mid_relief_stop,0,daily-deadhead-2,
```
