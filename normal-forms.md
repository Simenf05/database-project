# 1. normal form

It is trivial to see that all the tables have atomic values, and that there is no duplicate rows possible in any of the tables. Aswel as atmoicity, we have that the order of the rows don't play any role in how the data is understood.

# 2. normal form

## Trivial tables
All the tables with a primary key that is only the id is automatically in the second normal form. This goes for 'users', 'staff', 'centers', 'facilities', 'rooms', 'treadmills', 'bikes', 'sport_clubs'. This is because when the key is only an id, there can't be any partial dependencies on that key.

## Strikes and Instructor For
The tables 'strikes' and 'instructor_for' are in the second normal form because all the columns in the tables is part of the primary key. Therefore they has no partial dependencies on the primary key.

## Group sessions:
Primary key: 'start_time' and 'room_id'
Columns 'max_attendants', 'activity', 'creation_time' and 'duration' does not depend on anything other than the entire primary key. For 'max_attendants' doesn't depend on 'room_id' because an instructor can choose how many can attend the group session. 

## Registered and Attended
These tables are essentially the same, but 'registered_time' and 'showed_up' are different columns. Nither depends on anything but the entire primary key.

## Shift 
For the 'shift' table, the only

# BC


