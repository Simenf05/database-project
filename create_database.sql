CREATE TABLE users ( 
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	mail TEXT NOT NULL,
	phone_number TEXT
);

CREATE TABLE strikes (
	timestamp TIMESTAMP NOT NULL,
	session_time TIMESTAMP,
	session_room INTEGERL,
	user_id INTEGER,
	PRIMARY KEY (session_time, session_room, user_id, timestamp),
	FOREIGN KEY (session_time, session_room) REFERENCES group_sessions(start_time, room_id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE group_sessions (
	start_time TIMESTAMP,
	duration INTERVAL NOT NULL,
	creation_time TIMESTAMP NOT NULL,
	activity TEXT,
	max_attendants INTEGER,
	room_id INTEGER,
	PRIMARY KEY (start_time, room_id),
	FOREIGN KEY (room_id) REFERENCES rooms(id)
);

CREATE TABLE registered (
	register_time TIMESTAMP,
	session_time TIMESTAMP,
	session_room INTEGER,
	user_id INTEGER,
	PRIMARY KEY (session_time, session_room, user_id),
	FOREIGN KEY (session_time, session_room) REFERENCES group_sessions(start_time, room_id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE attended (
	showed_up BOOLEAN NOT NULL,
	session_time TIMESTAMP,
	session_room INTEGER,
	user_id INTEGER,
	PRIMARY KEY (session_time, session_room, user_id),
	FOREIGN KEY (session_time, session_room) REFERENCES group_sessions(start_time, room_id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE staff (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	first_name TEXT NOT NULL,
	last_name TEXT NOT NULL
);

CREATE TABLE instructor_for (
	staff_id INTEGER,
	session_time TIMESTAMP,
	session_room INTEGER,
	PRIMARY KEY (staff_id, session_time, session_room),
	FOREIGN KEY (staff_id) REFERENCES staff(id),
	FOREIGN KEY (session_time, session_room) REFERENCES group_sessions(start_time, room_id)
);

CREATE TABLE centers (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL,
	address TEXT NOT NULL,
	opening_time TIME,
	closing_time TIME
);

CREATE TABLE shifts (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	start_time TIMESTAMP NOT NULL,
	duration INTERVAL,
	center_id INTEGER NOT NULL,
	staff_id INTEGER NOT NULL,
	FOREIGN KEY (center_id) REFERENCES centers(id),
	FOREIGN KEY (staff_id) REFERENCES staff(id)
);

CREATE TABLE facilities (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	type TEXT NOT NULL
);

CREATE TABLE facility_at_center (
	facility_id INTEGER,
	center_id INTEGER,
	PRIMARY KEY (facility_id, center_id),
	FOREIGN KEY (facility_id) REFERENCES facilities(id),
	FOREIGN KEY (center_id) REFERENCES centers(id)
);

CREATE TABLE rooms (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	center_id INTEGER NOT NULL,
	FOREIGN KEY (center_id) REFERENCES centers(id)
);

CREATE TABLE treadmills (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	producer TEXT NOT NULL,
	max_speed TEXT NOT NULL,
	max_incline TEXT NOT NULL,
	number INTEGER NOT NULL,
	room_id INTEGER NOT NULL,
	FOREIGN KEY (room_id) REFERENCES rooms(id)
);

CREATE TABLE bikes (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	room_id INTEGER NOT NULL,
	FOREIGN KEY (room_id) REFERENCES rooms(id)
);

CREATE TABLE sports_clubs (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL
);

CREATE TABLE room_booking (
	start_time TIMESTAMP,
	duration INTERVAL NOT NULL,
	room_id INTEGER,
	club_id INTEGER,
	PRIMARY KEY (start_time, room_id, club_id),
	FOREIGN KEY (room_id) REFERENCES rooms(id),
	FOREIGN KEY (club_id) REFERENCES sports_clubs(id)
);
