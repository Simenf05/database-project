# Use case 2
```
Mail: johnny@stud.ntnu.no
Activity (* for wildcard): *
Year and date (YYYY-MM-DD): 2026-03-23
Select your session (q to exit):
1: 17:30:00 | 60 mins | Spin60
2: 18:00:00 | 60 mins | Spin70
3: 12:00:00 | 70 mins | Spin70
4: 10:00:00 | 30 mins | Spin30
5: 11:00:00 | 30 mins | Spin30
6: 12:00:00 | 30 mins | Spin30
7: 13:00:00 | 30 mins | Spin30
8: 14:00:00 | 30 mins | Spin30
9: 15:00:00 | 30 mins | Spin30
Session number: 1
Success
```

```
Mail: johnny@stud.ntnu.no
Activity (* for wildcard): *
Year and date (YYYY-MM-DD): 2026-03-23
Select your session (q to exit):
1: 17:30:00 | 60 mins | Spin60
2: 18:00:00 | 60 mins | Spin70
3: 12:00:00 | 70 mins | Spin70
4: 10:00:00 | 30 mins | Spin30
5: 11:00:00 | 30 mins | Spin30
6: 12:00:00 | 30 mins | Spin30
7: 13:00:00 | 30 mins | Spin30
8: 14:00:00 | 30 mins | Spin30
9: 15:00:00 | 30 mins | Spin30
Session number: 1
User already registered for a session during this time interval..
```

# Use case 3
```
Mail: johnny@stud.ntnu.no
Select your session to attend (q to exit):
1: Spin120 | Room: 1 | 2026-03-17 10:00
2: Spin120-2 | Room: 1 | 2026-03-18 10:00
3: Spin120-3 | Room: 1 | 2026-03-19 10:00
4: Spin120-4 | Room: 1 | 2026-03-20 10:00
5: Spin120-5 | Room: 1 | 2026-03-21 10:00
6: Spin60 | Room: 1 | 2026-03-23 17:30:00
Session number: 6
Did attendant show up (y/n): y
Success
```

# Use case 4
```
week number: 12
Day number (1 is Monday, 7 is Sunday): 1
Activity: Spin120 | description: 120 min spinning | start_time: 2026-03-17 10:00 | duration: 120
Activity: Spin60 | description: 60 min spinning | start_time: 2026-03-17 18:30 | duration: 60
Activity: Spin120-2 | description: 120 min spinning igjen | start_time: 2026-03-18 10:00 | duration: 120
Activity: Spin120-3 | description: 120 min spinning igjen | start_time: 2026-03-19 10:00 | duration: 120
Activity: Spin120-4 | description: 120 min spinning igjen | start_time: 2026-03-20 10:00 | duration: 120
Activity: Spin120-5 | description: 120 min spinning igjen | start_time: 2026-03-21 10:00 | duration: 120
```

# Use case 5
```
+-----------+------------------------------------+------------+---------------------+----------+
| activity  |            description             |    name    |    session_time     | duration |
+-----------+------------------------------------+------------+---------------------+----------+
| Spin120   | 120 min spinning                   | Gløshaugen | 2026-03-17 10:00    | 120      |
| Spin120-2 | 120 min spinning igjen             | Gløshaugen | 2026-03-18 10:00    | 120      |
| Spin120-3 | 120 min spinning igjen             | Gløshaugen | 2026-03-19 10:00    | 120      |
| Spin120-4 | 120 min spinning igjen             | Gløshaugen | 2026-03-20 10:00    | 120      |
| Spin120-5 | 120 min spinning igjen             | Gløshaugen | 2026-03-21 10:00    | 120      |
| Spin60    | Rommet har 2 sykler, vi bytter på. | Gløshaugen | 2026-03-23 17:30:00 | 60       |
+-----------+------------------------------------+------------+---------------------+----------+
```

# Use case 6
```
Runtime error near line 8: Cannot attend group session with three strikes (19)
```

# Use case 7
```
Year (2026, 2027, etc.): 2026
Month (1 = Jan, 2 = Feb, etc.): 3
Trained the most in March:
Johnny Etternavn has trained 6 times.
```

# Use case 8
```
+----------------------+----------------------+------------+
|        mail1         |        mail2         | occurences |
+----------------------+----------------------+------------+
| ola.normann@mail.no  | johnny@stud.ntnu.no  | 5          |
| ola.normann@mail.no  | kari.normann@mail.no | 2          |
| kari.normann@mail.no | johnny@stud.ntnu.no  | 2          |
+----------------------+----------------------+------------+
```
