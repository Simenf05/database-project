CREATE TABLE users ( 
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	mail TEXT NOT NULL UNIQUE,
	phone_number TEXT,
	member_in_club INTEGER,
	CHECK (mail LIKE '%_@__%.__%'),
	FOREIGN KEY (member_in_club) REFERENCES sports_clubs(id)
);

CREATE TABLE strikes (
	strike_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	session_time TIMESTAMP,
	session_room INTEGER,
	user_id INTEGER,
	PRIMARY KEY (session_time, session_room, user_id, strike_time),
	FOREIGN KEY (session_time, session_room) REFERENCES group_sessions(start_time, room_id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE group_sessions (
	start_time TIMESTAMP,
	duration INTEGER NOT NULL,
	creation_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	activity TEXT,
	max_attendants INTEGER,
	room_id INTEGER,
	club_id INTEGER,
	description TEXT,
	PRIMARY KEY (start_time, room_id),
	FOREIGN KEY (room_id) REFERENCES rooms(id),
	FOREIGN KEY (club_id) REFERENCES sports_clubs(id),
	CHECK (start_time > creation_time),
	CHECK (duration > 0)
);

CREATE TABLE registered (
	register_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	session_time TIMESTAMP,
	session_room INTEGER,
	user_id INTEGER,
	PRIMARY KEY (session_time, session_room, user_id),
	FOREIGN KEY (session_time, session_room) REFERENCES group_sessions(start_time, room_id),
	FOREIGN KEY (user_id) REFERENCES users(id),
	CHECK (register_time < session_time)
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
	opening_time TIME NOT NULL,
	closing_time TIME NOT NULL,
	CHECK (closing_time > opening_time)
);

CREATE TABLE shifts (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	start_time TIMESTAMP NOT NULL,
	duration INTEGER NOT NULL,
	center_id INTEGER NOT NULL,
	staff_id INTEGER,
	FOREIGN KEY (center_id) REFERENCES centers(id),
	FOREIGN KEY (staff_id) REFERENCES staff(id),
	CHECK (duration > 0)
);

CREATE TABLE facilities (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	type TEXT NOT NULL UNIQUE
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
	producer TEXT NOT NULL,
	max_speed INTEGER NOT NULL,
	max_incline INTEGER NOT NULL,
	number INTEGER,
	room_id INTEGER,
	PRIMARY KEY (number, room_id),
	FOREIGN KEY (room_id) REFERENCES rooms(id)
);

CREATE TABLE bikes (
	room_id INTEGER,
	bodybike BOOLEAN NOT NULL,
	number INTEGER,
	PRIMARY KEY (room_id, number),
	FOREIGN KEY (room_id) REFERENCES rooms(id)
);

CREATE TABLE sports_clubs (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL UNIQUE
);

CREATE TRIGGER staff_double_shift
BEFORE INSERT ON shifts
WHEN 
EXISTS (
	SELECT 1
	FROM shifts
	WHERE staff_id = NEW.staff_id
	AND NEW.start_time < datetime(start_time, '+' || duration || ' minutes')
	AND datetime(NEW.start_time, '+' || NEW.duration || ' minutes') > start_time
)
OR
EXISTS (
	SELECT 1
	FROM instructor_for i
	JOIN group_sessions g
	ON g.start_time = i.session_time
	AND g.room_id = i.session_room
	WHERE i.staff_id = NEW.staff_id
	AND NEW.start_time < datetime(g.start_time, '+' || g.duration || ' minutes')
	AND datetime(NEW.start_time, '+' || NEW.duration || ' minutes') > g.start_time
)
BEGIN
	SELECT RAISE(ABORT, 'Staff already busy during this time.');
END;

CREATE TRIGGER staff_double_group_session
BEFORE INSERT ON instructor_for
WHEN
EXISTS (
	SELECT 1
	FROM shifts
	JOIN group_sessions g
	ON g.start_time = NEW.session_time
	AND g.room_id = NEW.session_room
	WHERE shifts.staff_id = NEW.staff_id
	AND g.start_time < datetime(shifts.start_time, '+' || shifts.duration || ' minutes')
	AND datetime(g.start_time, '+' || g.duration || ' minutes') > shifts.start_time
)
OR
EXISTS (
	SELECT 1
	FROM instructor_for i
	JOIN group_sessions g1
	ON g1.start_time = NEW.session_time
	AND g1.room_id = NEW.session_room
	JOIN group_sessions g2
	ON g2.start_time = i.session_time
	AND g2.room_id = i.session_room
	WHERE i.staff_id = NEW.staff_id
	AND g1.start_time < datetime(g2.start_time, '+' || g2.duration || ' minutes')
	AND datetime(g1.start_time, '+' || g1.duration || ' minutes') > g2.start_time
)
BEGIN
	SELECT RAISE(ABORT, 'Staff already busy during this time.');
END;

CREATE TRIGGER user_double_group_session
BEFORE INSERT ON registered
WHEN EXISTS (
    SELECT 1
    FROM registered r
    JOIN group_sessions g
      ON g.start_time = r.session_time
     AND g.room_id = r.session_room
    JOIN group_sessions new_session
      ON new_session.start_time = NEW.session_time
     AND new_session.room_id = NEW.session_room
    WHERE r.user_id = NEW.user_id
      AND new_session.start_time < datetime(g.start_time, '+' || g.duration || ' minutes')
      AND datetime(new_session.start_time, '+' || new_session.duration || ' minutes') > g.start_time
)
BEGIN
    SELECT RAISE(ABORT, 'User already registered for a session during this time interval.');
END;

CREATE TRIGGER three_strikes
BEFORE INSERT ON registered
WHEN (
	SELECT COUNT(*)
	FROM strikes s
	WHERE s.user_id = NEW.user_id
	AND s.strike_time >= datetime('now', '-30 days')
	
) >= 3
BEGIN
	SELECT RAISE(ABORT, 'Cannot attend group session with three strikes');
END;

CREATE TRIGGER room_double_group_session
BEFORE INSERT ON group_sessions
WHEN EXISTS (
	SELECT 1
	FROM group_sessions g
	WHERE g.room_id = NEW.room_id
	AND NEW.start_time < datetime(g.start_time, '+' || g.duration || ' minutes')
	AND datetime(NEW.start_time, '+' || NEW.duration || ' minutes') > g.start_time
)
BEGIN
	SELECT RAISE(ABORT, 'Room already booked during this time.');
END;

CREATE TRIGGER issue_strike
AFTER DELETE ON registered 
WHEN CURRENT_TIMESTAMP > datetime(OLD.session_time, '-1 hour')
BEGIN
	INSERT INTO strikes (strike_time, session_time, session_room, user_id)
	VALUES (CURRENT_TIMESTAMP, OLD.session_time, OLD.session_room, OLD.user_id);
END;

CREATE TRIGGER registration_too_early
BEFORE INSERT ON registered
WHEN NEW.register_time < datetime(NEW.session_time, '-2 days')
BEGIN
    SELECT RAISE(ABORT, 'Cannot register more than 48 hours before session');
END;
