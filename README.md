# Database Project CLI

SQLite-backed command-line app for group session booking and statistics.

## Table of contents

- [Prerequisites](#prerequisites)
- [DB initialization](#db-initialization)
- [Run help](#run-help)
- [Commands](#commands)
	- [`register`](#register)
	- [`attend`](#attend)
	- [`schedule`](#schedule)
	- [`most-group-sessions`](#most-group-sessions)
- [Terminal usage examples](#terminal-usage-examples)
- [Testing use cases (2-8)](#testing-use-cases-2-8)
	- [Use case 2: Booking of `Spin60` (CLI)](#use-case-2-booking-of-spin60-cli)
	- [Use case 3: Register attendance for the booking (CLI)](#use-case-3-register-attendance-for-the-booking-cli)
	- [Use case 4: Weekly schedule for week 12 (CLI)](#use-case-4-weekly-schedule-for-week-12-cli)
	- [Use case 5: Personal visit history for Johnny since 2026-01-01 (SQL)](#use-case-5-personal-visit-history-for-johnny-since-2026-01-01-sql)
	- [Use case 6: Blacklisting after three strikes in 30 days (SQL + optional CLI check)](#use-case-6-blacklisting-after-three-strikes-in-30-days-sql--optional-cli-check)
	- [Use case 7: Person(s) with most attended group sessions in a month (CLI)](#use-case-7-persons-with-most-attended-group-sessions-in-a-month-cli)
	- [Use case 8: Find people who train together (SQL)](#use-case-8-find-people-who-train-together-sql)
- [Assumptions](#assumptions)

## Prerequisites

- Python 3.10+
- SQLite3 (`sqlite3` CLI available in terminal)

## DB initialization

Run from project root:

```text
cd code
sqlite3 database.db
```

Then inside the SQLite shell:

```sql
.read create_database.sql
.read seeding.sql
.quit
```

## Run help

```text
cd code
python sitcli.py help
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

```text
# show help
cd code
python sitcli.py help

# book a session
python sitcli.py register

# register attendance
python sitcli.py attend

# show weekly schedule
python sitcli.py schedule

# show monthly top attendee(s)
python sitcli.py most-group-sessions
```

## Testing use cases (2-8)

Run DB setup first (from project root):

```text
cd code
sqlite3 database.db
```

Then inside the SQLite shell:

```sql
.read create_database.sql
.read seeding.sql
.quit
```

Use case 1 is just the seeding SQL script, so it won't be covered in this section.

### Use case 2: Booking of `Spin60` (CLI)

Use the `register` command.

```text
cd code
python sitcli.py register
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

```text
cd code
python sitcli.py attend
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

```text
cd code
python sitcli.py schedule
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

```text
cd code
sqlite3 database.db
```

Then inside the SQLite shell:

```sql
.read johnny_history.sql
.quit
```

What to verify:

- Output includes activity, center, datetime, and duration.
- Rows are unique (`DISTINCT`).

---

### Use case 6: Blacklisting after three strikes in 30 days (SQL + optional CLI check)

Run the strike test script:

```text
cd code
sqlite3 database.db
```

Then inside the SQLite shell:

```sql
.read test_strikes.sql
.quit
```

What to verify:

- The final registration attempt fails due to the 3-strike rule.
- Error message should indicate blocked registration when three recent strikes exist.

Optional extra check with CLI:

```text
cd code
python sitcli.py register
```

Try booking for the same blocked user and confirm booking is rejected.

---

### Use case 7: Person(s) with most attended group sessions in a month (CLI)

Use the `most-group-sessions` command.

```text
cd code
python sitcli.py most-group-sessions
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

```text
cd code
sqlite3 database.db
```

Then inside the SQLite shell:

```sql
.read training_pairs.sql
.quit
```

What to verify:

- Output contains two emails + count of joint sessions.
- Rows are ordered by number of joint sessions (descending).

---

## Assumptions


- **Use case 2 interpretation:** We assume the term "booking" refers to registering for a group session.
- **User identity:** In our schema, we don't have a field for username, we therefore use the users mail as identifier, as this is unique for a given user.
- **Date/session constraints:** As mentioned earlier in the readme, one cannot register a session in the past. We have therefore added some dynamically added date with the seeding script that sets the date to the next day. Use these to test registering.
- **Seeding behavior:** Running the seeding script removed all existing data before adding its own. This is to make sure the foreign relations regarding IDs point to the correct counterparts. Because of the dynamically added dates, and constraints in our file, make sure to seed the database before testing to ensure being able to register and attend.
- **Overlap rule:** The only change we made to the schema is to add a new trigger that aborts any insertions into the registered table, if the user already is registered for another session with times overlapping the new session.
- **Use case 6 scope:** For usecase 6, we haven't implemented any python code. The behaviour described in the usecase is sufficiently handled from previously made triggers, meaning a quick test using the SQL script mentioned earlier is sufficient to prove the use case is implemented.

---

## AI-declaration

- See [texts/AI-declaration.md](texts/AI-declaration.md)
