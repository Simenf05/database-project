INSERT INTO sports_clubs (name) VALUES ('Test Club');

INSERT INTO centers (name, address, opening_time, closing_time) 
VALUES ('Test Center', 'Street 1', '06:00', '22:00');

INSERT INTO rooms (center_id) VALUES (1);

INSERT INTO users (first_name, last_name, mail, member_in_club)
VALUES ('Ola', 'Nordmann', 'ola.nordmann@example.com', 1);

INSERT INTO group_sessions (start_time, duration, activity, max_attendants, room_id, club_id, description)
VALUES (
    '2026-03-10 10:00:00', 60, 'Yoga', 10, 1, 1, 'Morgen Yoga'
);

INSERT INTO strikes (session_time, session_room, user_id) 
VALUES ('2026-03-01 10:00:00', 1, 1);
INSERT INTO strikes (session_time, session_room, user_id) 
VALUES ('2026-03-02 11:00:00', 1, 1);
INSERT INTO strikes (session_time, session_room, user_id) 
VALUES ('2026-03-03 12:00:00', 1, 1);

INSERT INTO group_sessions (start_time, duration, activity, max_attendants, room_id, club_id, description)
VALUES (
    '2026-03-15 10:00:00', 60, 'Pilates', 10, 1, 1, 'Pilates session'
);

INSERT INTO registered (session_time, session_room, user_id)
VALUES ('2026-03-15 10:00:00', 1, 1);
