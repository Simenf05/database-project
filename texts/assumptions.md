We assume that booking in usecase 2 reffers to registering for a group session.
Epost er brukernavn

Vi har en constraint som sier at man ikke kan legge til en group_session som har start time i fortiden. Datoer kommer derfor ikke til å stemme overens med oppgaven. Seeding-skriptet velger datoer som er i dag + 1 dag, slik at man alltid kan melde seg på (innen 48 timer av start). Det er derfor viktig å seede før bruk - seeding sletter hele databasen før den putter inn ny data.

We assume that booking in usecase 2 reffers to registering for a group session.
Epost er brukernavn

We had to implement a new constraint on insertions to the registered table to prevent people from registering for multiple sessions with overlapping session times. The constraint is applied through the user_double_group_session trigger.

For usecase 6 we haven't implemented any new features because it is sufficiently covered by our triggers. Therefore we only handle the cases where one tries to register for a session with three strikes, the insertion to the table is aborted, and a message is displayed to the user.
