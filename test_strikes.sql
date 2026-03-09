-- 1. Sett opp nødvendig data: klubb, rom, rom, og gruppeøkt
INSERT INTO sports_clubs (name) VALUES ('Test Club');

INSERT INTO centers (name, address, opening_time, closing_time) 
VALUES ('Test Center', 'Street 1', '06:00', '22:00');

INSERT INTO rooms (center_id) VALUES (1);

-- 2. Opprett en bruker
INSERT INTO users (first_name, last_name, mail, member_in_club)
VALUES ('Ola', 'Nordmann', 'ola.nordmann@example.com', 1);

-- 3. Opprett en gruppeøkt som brukeren kunne registrere seg på
INSERT INTO group_sessions (start_time, duration, activity, max_attendants, room_id, club_id, description)
VALUES (
    '2026-03-10 10:00:00', 60, 'Yoga', 10, 1, 1, 'Morgen Yoga'
);

-- 4. Gi brukeren tre strikes manuelt
INSERT INTO strikes (session_time, session_room, user_id) 
VALUES ('2026-03-01 10:00:00', 1, 1);
INSERT INTO strikes (session_time, session_room, user_id) 
VALUES ('2026-03-02 11:00:00', 1, 1);
INSERT INTO strikes (session_time, session_room, user_id) 
VALUES ('2026-03-03 12:00:00', 1, 1);

-- 5. Opprett en ny gruppeøkt som brukeren prøver å registrere seg på
INSERT INTO group_sessions (start_time, duration, activity, max_attendants, room_id, club_id, description)
VALUES (
    '2026-03-15 10:00:00', 60, 'Pilates', 10, 1, 1, 'Pilates session'
);

-- 6. Forsøk å registrere brukeren på den nye økten
-- Dette skal feile pga. three_strikes triggeren
INSERT INTO registered (session_time, session_room, user_id)
VALUES ('2026-03-15 10:00:00', 1, 1);
