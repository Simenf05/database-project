SELECT
	u1.mail AS mail1,
	u2.mail AS mail2,
	COUNT(*) AS occurences
FROM (
	users AS u
	INNER JOIN attended AS a ON u.id = a.user_id
) AS u1
CROSS JOIN
(
	users AS u
	INNER JOIN attended AS a ON u.id = a.user_id
) AS u2
WHERE (
	u1.session_time = u2.session_time
	AND u1.session_room = u2.session_room
	AND u1.showed_up = TRUE
	AND u2.showed_up = TRUE
	AND u1.user_id < u2.user_id
)
GROUP BY
	u1.user_id,
	u1.first_name,
	u1.last_name,
	u1.user_id,
	u2.first_name,
	u2.last_name
ORDER BY occurences DESC;
