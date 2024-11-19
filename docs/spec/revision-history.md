# Revision History

## 24 July 2024

TODS v2.0.0 is adopted.<br>
* Removes file `runs_pieces.txt`.
* Amends `run_events.txt` to allow for runs to be represented explicitly and tied directly to constituent trips, and combines the key information from runs_pieces.txt into run_events.txt, treating trips as individual events in the full sequence of run events
   * The proposal also includes a new job_type field that allows for TODS to represent multiple employees working on a single trip.

## 20 June 2024

TODS v2.0.0-alpha.1 is adopted.<br>
* Removes files `deadheads.txt`, `ops_locations.txt`, `deadhead_times.txt`.<br>
* Adds new files `trips_supplement.txt`, `stops_supplement.txt`, `stop_times_supplement.txt`, and `routes_supplement.txt`.<br>
   * Allows for supplementation, modification, and/or deletion of data in existing GTFS feed.

## 3 May 2022

TODS v1.0.0 is adopted by the TODS Working Group
