
# sitcli

`sitcli` is a small command-line tool for managing group training sessions stored in a SQLite database. With this app, you can:

* register a user for a group session
* mark attendance for a session
* view the schedule for a given week
* find the user(s) who attended the most sessions in a month

The app connects to a SQLite database located at:

```bash
../database.db
```

---

## Requirements

* Python 3
* A SQLite database with the required tables and data
* The database must be located at `../database.db` relative to the script

---

## Usage

Run the program from the terminal:

```bash
python3 sitcli.py [COMMAND]
```

or, if executable:

```bash
./sitcli.py [COMMAND]
```

---

## Available Commands

* `register`
* `attend`
* `schedule`
* `most-group-sessions`
* `help`

---

## 1. `register`

Registers a user for a group session.

### Run

```bash
python3 sitcli.py register
```

### Input

You will be prompted for:

* `Mail` – the user's email address
* `Activity` – activity name
* `Year and date (YYYY-MM-DD)` – session date

### Wildcard Search

You can use `*` as a wildcard in the activity field.

Example:

```text
Activity (* for wildcard): Yog*
```

### Example

```text
Mail: ola@example.com
Activity (* for wildcard): Spin*
Year and date (YYYY-MM-DD): 2026-04-15
Select your session (q to exit):
1: 18:00:00 | 60 mins | Spinning
2: 19:30:00 | 45 mins | Spinning Intro
Session number: 1
Success
```

### Possible Errors

* `Not a valid mail.`
* `Not a valid date.`
* `No sessions at this date.`
* `Already registered for this session.`
* `Cannot register for session in the past.`

---

## 2. `attend`

Marks whether a user attended a session they are registered for.

### Run

```bash
python3 sitcli.py attend
```

### Input

* `Mail` – the user's email
* select a session from the list
* indicate whether the user showed up (`y/n`)

### Example

```text
Mail: ola@example.com
Select your session to attend (q to exit):
1: Spinning | Room: 2 | 2026-04-15 18:00:00
Session number: 1
Did attendant show up (y/n): y
Success
```

### Possible Errors

* `You are not registered for any group sessions.`
* `Already attended this session.`

---

## 3. `schedule`

Displays all group sessions for a given week and day.

### Run

```bash
python3 sitcli.py schedule
```

### Input

* `week number` – ISO week (1–53)
* `day number` – day of the week (1 = Monday, 7 = Sunday)

### Example

```text
week number: 16
Day number (1 is Monday, 7 is Sunday): 3
Activity: Yoga | description: Morning session | start_time: 2026-04-15 08:00:00 | duration: 60
Activity: Spinning | description: High intensity | start_time: 2026-04-15 18:00:00 | duration: 45
```

### Possible Errors

* `Week must be between 1 and 53`
* `Day must be between 1 and 7`
* `No sessions found in this time interval`

---

## 4. `most-group-sessions`

Shows the user(s) who attended the most sessions in a given month.

### Run

```bash
python3 sitcli.py most-group-sessions
```

### Input

* `Year` – e.g. 2026
* `Month` – 1–12

### Example

```text
Year (2026, 2027, etc.): 2026
Month (1 = Jan, 2 = Feb, etc.): 4
Trained the most in April:
Ola Nordmann has trained 12 times.
```

### Possible Errors

* `Month and year must be a number.`
* `Month must be in the range 1 to 12 inclusive.`
* `No people trained.`

---

## 5. `help`

Displays a short overview of available commands.

```bash
python3 sitcli.py help
```

---

## Notes

* `%` is not allowed in input (used internally in SQL queries)
* `*` can be used as a wildcard in activity searches
* The app uses SQL `LIKE`, allowing flexible matching
* The database enforces constraints such as:

  * unique registrations
  * no registration for past sessions

---

## Summary

`sitcli` is a simple CLI tool for managing training sessions via a SQLite database. It provides basic functionality for registration, attendance tracking, scheduling, and statistics directly from the terminal.
