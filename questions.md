1. How (or can) you ensure that an instructor cannot be present in two different places at the same time? Can you achieve this using your model, or does something like this have to be implemented in the software.

We have implemented this with a trigger that fires on insert to the 'shifts' and 'instructor_for' tables. The trigger check if the staff already is working during this time. If the staff already works, the insert will be aborted. 

2. The same question for a user. Can this be solved in the model or must it be done in the software?

We also have a trigger for when inserting to the 'user' table. The trigger checks if the user already is registered for another group session, and aborts the insert if the user already is registered for another group session.

3. From which use case is the exclusion (blacklisting) tested / created? It does not have to be one of the stated use cases.

When a user tries to remove their registration less than one hour before session start, a strike is awarded. Trying to register for a session while having three strikes results in an error stating one cannot attend a group session with thre active strikes. A strike is active for 30 days after issue. Whether a strike is active or not is not excplicitly stored as a column, but calculated from 'strike_time' when trying to register for a group session. This behaviour is tested in the file test_strikes.sql.

4. Are statistics something that must be stored explicitly or is it possible to just make queries to get answers? Discuss this.

For many statistics it is possible to use queries to find relevant information from the database. Therefore there is no tables that represent statistics explicitly. To have more statistics available in the database, we could change the registration from deleting rows, to instead be a boolean. That way the database would have statistics for every user that a some point was registered for the group session.
