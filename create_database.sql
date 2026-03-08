CREATE TABLE users ( 
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	first_name TEXT,
	last_name TEXT,
	mail TEXT,
	phone_number TEXT
);

CREATE TABLE strikes (
	timestamp TIMESTAMP,
	session_time TIMESTAMP,
	session_room INTEGER,
	user_id INTEGER,
	PRIMARY KEY (session_time, session_room, user_id, timestamp),
	FOREIGN KEY (session_time, session_room) REFERENCES group_sessions(start_time, room_id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE group_sessions (
	start_time TIMESTAMP,
	duration INTERVAL,
	creation_time TIMESTAMP,
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
	showed_up BOOLEAN,
	session_time TIMESTAMP,
	session_room INTEGER,
	user_id INTEGER,
	PRIMARY KEY (session_time, session_room, user_id),
	FOREIGN KEY (session_time, session_room) REFERENCES group_sessions(start_time, room_id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE staff (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	first_name TEXT,
	last_name TEXT
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
	name TEXT,
	address TEXT,
	opening_time TIME,
	closing_time TIME
);

CREATE TABLE shift (
	start_time TIMESTAMP,
	duration INTERVAL,
	center_id INTEGER,
	staff_id INTEGER,
	PRIMARY KEY (start_time, center_id, staff_id),
	FOREIGN KEY (center_id) REFERENCES centers(id),
	FOREIGN KEY (staff_id) REFERENCES staff(id)
);

CREATE TABLE facilities (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	type TEXT
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
	center_id INTEGER,
	FOREIGN KEY (center_id) REFERENCES centers(id)
);

CREATE TABLE treadmills (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	producer TEXT,
	max_speed TEXT,
	max_incline TEXT,
	number INTEGER,
	room_id INTEGER,
	FOREIGN KEY (room_id) REFERENCES rooms(id)
);

CREATE TABLE bikes (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	room_id INTEGER,
	FOREIGN KEY (room_id) REFERENCES rooms(id)
);

CREATE TABLE sports_clubs (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT
);

CREATE TABLE room_booking (
	start_time TIMESTAMP,
	duration INTERVAL,
	room_id INTEGER,
	club_id INTEGER,
	PRIMARY KEY (start_time, room_id, club_id),
	FOREIGN KEY (room_id) REFERENCES rooms(id),
	FOREIGN KEY (club_id) REFERENCES sports_clubs(id)
);
