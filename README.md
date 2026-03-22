# Database Project CLI

SQLite-backed command-line app for group session booking and statistics.

## Prerequisites

- Python 3.10+
- SQLite3 (`sqlite3` CLI available in terminal)

## DB initialization

Run from project root:

```bash
cd code
sqlite3 database.db < create_database.sql
sqlite3 database.db < seeding.sql
```

## Run help

```bash
cd code
python3 sitcli.py help
```

## Commands

### `register`
Interactive booking flow.

Prompts for:
- `Mail`
- `Activity` (supports `*` wildcard)
- `Year and date` (`YYYY-MM-DD`)
- Session number from the listed matches

### `attend`
Interactive attendance registration for previously booked sessions.

Prompts for:
- `Mail`
- Session number from your registered sessions
- Whether the participant showed up (`y`/`n`)

### `schedule`
Shows sessions for a selected week/day range in the current year.

Prompts for:
- Week number (`1-53`)
- Day number (`1-7`, where `1` is Monday)

### `most-group-sessions`
Shows the user(s) with most attended sessions in a selected month.

Prompts for:
- Year (for example `2026`)
- Month (`1-12`)

## Terminal usage examples

```bash
# show help
cd code
python3 sitcli.py help

# book a session
python3 sitcli.py register

# register attendance
python3 sitcli.py attend

# show weekly schedule
python3 sitcli.py schedule

# show monthly top attendee(s)
python3 sitcli.py most-group-sessions
```

## Testing use cases (2-8)

Run DB setup first (from project root):

```bash
cd code
sqlite3 database.db < create_database.sql
sqlite3 database.db < seeding.sql
```

Use case 1 is just the seeding SQL script, so it won't be covered in this section.

### Use case 2: Booking of `Spin60` (CLI)

Use the `register` command.

```bash
cd code
python3 sitcli.py register
```

Because of a constraint in SQL, one cannot attend a group session in the past. We have therefore decided to add some sessions in the next day relative to when the seeding command is run. To test registering, use those sessions. See assumptions section below.

Suggested input:

```text
Mail: johnny@stud.ntnu.no
Activity (* for wildcard): Spin60
Year and date (YYYY-MM-DD): 2026-03-17
Session number: 1
```

What to verify:

- A matching session is listed.
- Booking succeeds with `Success`.
- If you run the same booking again, you should get an "already registered" error.

---

### Use case 3: Register attendance for the booking (CLI)

Use the `attend` command.

```bash
cd code
python3 sitcli.py attend
```

Suggested input:

```text
Mail: johnny@stud.ntnu.no
Session number: 1
Did attendant show up (y/n): y
```

What to verify:

- You can select the booked session.
- Attendance insert succeeds with `Success`.

---

### Use case 4: Weekly schedule for week 12 (CLI)

Use the `schedule` command.

```bash
cd code
python3 sitcli.py schedule
```

Suggested input:

```text
week number: 12
Day number (1 is Monday, 7 is Sunday): 1
```

What to verify:

- Output is sorted by start time.
- Sessions from all centers are shown in a single merged list.

---

### Use case 5: Personal visit history for Johnny since 2026-01-01 (SQL)

Run the provided query file:

```bash
cd code
sqlite3 database.db < johnny_history.sql
```

What to verify:

- Output includes activity, center, datetime, and duration.
- Rows are unique (`DISTINCT`).

---

### Use case 6: Blacklisting after three strikes in 30 days (SQL + optional CLI check)

Run the strike test script:

```bash
cd code
sqlite3 database.db < test_strikes.sql
```

What to verify:

- The final registration attempt fails due to the 3-strike rule.
- Error message should indicate blocked registration when three recent strikes exist.

Optional extra check with CLI:

```bash
cd code
python3 sitcli.py register
```

Try booking for the same blocked user and confirm booking is rejected.

---

### Use case 7: Person(s) with most attended group sessions in a month (CLI)

Use the `most-group-sessions` command.

```bash
cd code
python3 sitcli.py most-group-sessions
```

Suggested input:

```text
Year (2026, 2027, etc.): 2026
Month (1 = Jan, 2 = Feb, etc.): 3
```

What to verify:

- Output shows one or more top users.
- If there is a tie, all tied users are listed.

---

### Use case 8: Find people who train together (SQL)

Run the provided query file:

```bash
cd code
sqlite3 database.db < training_pairs.sql
```

What to verify:

- Output contains two emails + count of joint sessions.
- Rows are ordered by number of joint sessions (descending).

---
 # Assumptions
