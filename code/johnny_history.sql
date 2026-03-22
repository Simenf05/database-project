SELECT DISTINCT activity, description, name, session_time, duration
FROM users AS u
INNER JOIN attended AS a ON u.id = a.user_id
INNER JOIN group_sessions AS gr
ON (
	a.session_time = gr.start_time
	AND a.session_room = gr.room_id
)
INNER JOIN rooms AS r ON r.id = gr.room_id
INNER JOIN centers AS c ON c.id = r.center_id
WHERE u.mail = 'johnny@stud.ntnu.no'
AND gr.start_time > '2026-01-01 00:01';
