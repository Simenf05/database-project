# 1. normal form

It is trivial to see that all the tables have atomic values, and that there is no duplicate rows possible in any of the tables. Aswel as atmoicity, we have that the order of the rows don't play any role in how the data is understood.

# 2. normal form

## Trivial tables
All the tables with a primary key that is only the id is automatically in the second normal form. This goes for 'shifts', 'users', 'staff', 'centers', 'facilities', 'rooms', 'treadmills', 'bikes', 'sport_clubs'. This is because when the key is only an id, there can't be any partial dependencies on that key.

## Strikes, Instructor For and Facility at center
The tables 'strikes', 'facility_at_center' and 'instructor_for' are in the second normal form because all the columns in the tables is part of the primary key. Therefore they has no partial dependencies on the primary key.

## Group sessions
Primary key: 'start_time' and 'room_id'
Columns 'max_attendants', 'activity', 'creation_time', 'club_id', 'description' and 'duration' does not depend on anything other than the entire primary key. For 'max_attendants' doesn't depend on 'room_id' because an instructor can choose how many can attend the group session. 

## Registered and Attended
These tables are essentially the same, but 'registered_time' and 'showed_up' are different columns. Nither depends on anything but the entire primary key.

# BCNF
When a table is in BCNF, it is impossible for transitive dependency to occur, meaning it is also in thrid normal form. Therefore we omit writing about the thrid normal form.

## All columns are part of the primary key
The tables 'strikes', 'facility_at_center' and 'instructor_for' is trivial because the primary key is the entire table. 

## Only one column along with the primary key
Tables that only include one column and the primary key are also trivial. These tables are 'registered', 'attended', 'rooms', 'sport_clubs' and 'facilities'.

## Users, centers, shifts, staff and group sessions
'shifts', 'centers', 'staff', 'users', 'treadmills' and 'group-sessions' is the BCNF because none of the columns depend on any other column except for the primary key, id.

## Treadmills and bikes
The 'bikes', and 'treadmill' have a composite primary key, consisting of the 'room_id' and 'number'. All the other columns only depend on the primary key. 
