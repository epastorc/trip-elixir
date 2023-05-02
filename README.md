# Trip

## Take into account

* The trip name is a index, starting from 0
* The trips are sorted. A trip ends when there is a segment that has as destiny the based on (instead of use the rule of 24h).

## Result

```
TRIP to 0
Flight from SVQ to BCN at  20:40 to 22:10
Hotel at BCN on 2023-01-05 to 2023-01-10
Flight from BCN to SVQ at  10:30 to 11:50

TRIP to 1
Train from SVQ to MAD at  09:30 to 11:00
Hotel at MAD on 2023-02-15 to 2023-02-17
Train from MAD to SVQ at  17:00 to 19:30

TRIP to 2
Flight from SVQ to BCN at  06:40 to 09:10
Flight from BCN to NYC at  15:00 to 22:45
Flight from NYC to BOS at  08:00 to 09:25
```

## External dependencies

* Timex to compare dates(only take into account until minutes) 
