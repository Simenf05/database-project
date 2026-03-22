We assume that booking in usecase 2 reffers to registering for a group session.
Epost er brukernavn

Vi har en constraint som sier at man ikke kan legge til en group_session som har start time i fortiden. Datoer kommer derfor ikke til å stemme overens med oppgaven. Seeding-skriptet velger datoer som er i dag + 1 dag, slik at man alltid kan melde seg på (innen 48 timer av start). Det er derfor viktig å seede før bruk - seeding sletter hele databasen før den putter inn ny data.

We assume that booking in usecase 2 reffers to registering for a group session.
Epost er brukernavn

For usecase 6 we don't implement any new
