1. How (or can) you ensure that an instructor cannot be present in two different places at the same time? Can you achieve this using your model, or does something like this have to be implemented in the software.

We have implemented this with a trigger that fires on insert to the 'shifts' and 'instructor_for' tables. The trigger check if the staff already is working during this time. If the staff already works, the insert will be aborted. 

2. The same question for a user. Can this be solved in the model or must it be done in the software?

We also have a trigger for when inserting to the 'user' table. The trigger checks if the user already is registered for another group session, and aborts the insert if the user already is registered for another group session.
