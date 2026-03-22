DELETE FROM centers;
DELETE FROM rooms;
DELETE FROM bikes;
DELETE FROM users;
DELETE FROM staff;
DELETE FROM group_sessions;
DELETE FROM instructor_for;
DELETE FROM registered;
DELETE FROM attended;
DELETE FROM strikes;

UPDATE SQLITE_SEQUENCE SET seq = 0
WHERE (
	name = 'centers'
	OR name = 'rooms'
	OR name = 'users'
	OR name = 'staff'
);

INSERT INTO centers (name, address, opening_time, closing_time)
VALUES 	('Gløshaugen', 'Chr. Fredriks gate 20', '05:00', '23:59'),
	('Moholt', 'Moholt almenning 12', '05:00', '23:59'),
	('Øya', 'Vangslundsgate 2', '05:00', '23:59');

INSERT INTO rooms (center_id)
VALUES 	(1),
	(1),
	(2);

INSERT INTO bikes (room_id, bodybike, number)
VALUES	(1, false, 1),
	(1, true, 2),
	(2, false, 1);

INSERT INTO users (first_name, last_name, mail, phone_number, member_in_club)
VALUES	('Ola', 'Normann', 'ola.normann@mail.no', '12345678', NULL),
	('Kari', 'Normann', 'kari.normann@mail.no', '87654321', NULL),
	('Navn', 'Navnesen', 'navn.navnesen@mail.no', '00000000', NULL),
	('Johnny', 'Etternavn', 'johnny@stud.ntnu.no', '11111111', NULL);

INSERT INTO staff (first_name, last_name)
VALUES	('Tre', 'Ner'),
	('Ins', 'Truktør');

INSERT INTO group_sessions (start_time, duration, activity, max_attendants, room_id, creation_time, club_id, description)
VALUES
(
    datetime(date('now', '+1 day') || ' 17:30'),
    60, 'Spin60', 10, 1, date('now'), null,
    'Rommet har 2 sykler, vi bytter på.'
),
(
    datetime(date('now', '+1 day') || ' 18:00'),
    60, 'Spin70', 10, 2, date('now'), null,
    'Rommet har 2 sykler, vi bytter på.'
),
(
    datetime(date('now', '+1 day') || ' 12:00'),
    70, 'Spin70', 10, 2, date('now'), null,
    'Rommet har 2 sykler, vi bytter på.'
),
('2026-03-17 10:00', 120, 'Spin120', 10, 1, '2026-02-18', null, '120 min spinning'),
('2026-03-18 10:00', 120, 'Spin120-2', 10, 1, '2026-02-18', null, '120 min spinning igjen'),
('2026-03-19 10:00', 120, 'Spin120-3', 10, 1, '2026-02-18', null, '120 min spinning igjen'),
('2026-03-20 10:00', 120, 'Spin120-4', 10, 1, '2026-02-18', null, '120 min spinning igjen'),
('2026-03-21 10:00', 120, 'Spin120-5', 10, 1, '2026-02-18', null, '120 min spinning igjen'),
('2026-03-17 18:30', 60, 'Spin60', 10, 1, '2026-02-15', null, '60 min spinning'),
(
    datetime(date('now', '+1 day') || ' 10:00'),
    30, 'Spin30', 10, 3, date('now'), null,
    'Spinning i 30 min'
),
(
    datetime(date('now', '+1 day') || ' 11:00'),
    30, 'Spin30', 10, 3, date('now'), null,
    'Spinning i 30 min'
),
(
    datetime(date('now', '+1 day') || ' 12:00'),
    30, 'Spin30', 10, 3, date('now'), null,
    'Spinning i 30 min'
),
(
    datetime(date('now', '+1 day') || ' 13:00'),
    30, 'Spin30', 10, 3, date('now'), null,
    'Spinning i 30 min'
),
(
    datetime(date('now', '+1 day') || ' 14:00'),
    30, 'Spin30', 10, 3, date('now'), null,
    'Spinning i 30 min'
),
(
    datetime(date('now', '+1 day') || ' 15:00'),
    30, 'Spin30', 10, 3, date('now'), null,
    'Spinning i 30 min'
);

INSERT INTO instructor_for (staff_id, session_time, session_room)
VALUES	(1, '2026-10-12 18:00', 1);

INSERT INTO registered (register_time, session_room, session_time, user_id)
VALUES	('2026-03-16 10:00', 1, '2026-03-17 10:00', 4),
	('2026-03-17 10:00', 1, '2026-03-18 10:00', 4),
	('2026-03-18 10:00', 1, '2026-03-19 10:00', 4),
	('2026-03-19 10:00', 1, '2026-03-20 10:00', 4),
	('2026-03-20 10:00', 1, '2026-03-21 10:00', 4),
	('2026-03-16 10:00', 1, '2026-03-17 10:00', 1),
	('2026-03-17 10:00', 1, '2026-03-18 10:00', 1),
	('2026-03-18 10:00', 1, '2026-03-19 10:00', 1),
	('2026-03-19 10:00', 1, '2026-03-20 10:00', 1),
	('2026-03-20 10:00', 1, '2026-03-21 10:00', 1),
	('2026-03-18 10:00', 1, '2026-03-19 10:00', 2),
	('2026-03-19 10:00', 1, '2026-03-20 10:00', 2);

INSERT INTO attended (showed_up, session_room, session_time, user_id)
VALUES	(TRUE, 1, '2026-03-17 10:00', 4),
	(TRUE, 1, '2026-03-18 10:00', 4),
	(TRUE, 1, '2026-03-19 10:00', 4),
	(TRUE, 1, '2026-03-20 10:00', 4),
	(TRUE, 1, '2026-03-21 10:00', 4),
	(TRUE, 1, '2026-03-17 10:00', 1),
	(TRUE, 1, '2026-03-18 10:00', 1),
	(TRUE, 1, '2026-03-19 10:00', 1),
	(TRUE, 1, '2026-03-20 10:00', 1),
	(TRUE, 1, '2026-03-21 10:00', 1),
	(TRUE, 1, '2026-03-20 10:00', 2),
	(TRUE, 1, '2026-03-21 10:00', 2);
