#!/bin/env python3

import sqlite3
import calendar
import sys
from datetime import date, datetime, timedelta

con = sqlite3.connect("../database.db")
cursor = con.cursor()

def session_room_center_join():
    return "group_sessions AS g INNER JOIN rooms AS r ON (g.room_id = r.id) INNER JOIN centers AS c ON (r.center_id = c.id)"

def user_registered_for_group_sessions():
    return "group_sessions AS g INNER JOIN registered AS reg ON (g.start_time = reg.session_time AND g.room_id = reg.session_room) INNER JOIN users AS u ON (reg.user_id = u.id)"

def user_attendant_join():
    return "users AS u INNER JOIN attended AS a ON u.id = a.user_id"


# Antagelse: Epost er brukernavn

def register():
    mail = input("Mail: ")
    if "%" in mail:
        print("Not a valid mail.")
        return

    activity = input("Activity (* for wildcard): ").replace("*", "%") # 

    year_and_date = input("Year and date (YYYY-MM-DD): ")
    if "%" in year_and_date:
        print("Not a valid date.")
        return

    query = f"SELECT time(start_time), room_id, duration, start_time, activity FROM {session_room_center_join()} WHERE g.activity LIKE ? AND date(g.start_time) = ?"

    cursor.execute(query, (activity, year_and_date,))
    sessions_at_date = cursor.fetchall()
    
    if len(sessions_at_date) < 1:
        print("No sessions at this date.")
        return
    print("Select your session (q to exit):")

    while True:
        for i, session in enumerate(sessions_at_date):
            print(f"{i + 1}: {session[0]} | {session[2]} mins | {session[4]}")
        try:
            value = input("Session number: ")
            if value in {"exit", "Exit", "q", "Q"}:
                return
            index = int(value) - 1
            selected = sessions_at_date[index]
        except:
            print("Not valid id")
            print()
            continue;
        break


    query = "SELECT id FROM users WHERE mail LIKE ?"
    cursor.execute(query, (mail,))
    user_id = cursor.fetchone()

    insert_query = "INSERT INTO registered (session_time, session_room, user_id) VALUES (?, ?, ?)"
    try:
        cursor.execute(insert_query, (selected[3], selected[1], user_id[0],))
        con.commit()
        print("Success")
    except Exception as e:
        text = str(e)
        if text.startswith("UNIQUE"):
            print("Already registered for this session.")
            return
        if "register_time < session_time" in text:
            print("Cannot register for session in the past.")
            return
        print(str(e), end=".\n")


def attend():
    mail = input("Mail: ")
    if "%" in mail:
        print("Not a valid mail.")
        return

    query = f"SELECT start_time, room_id, activity, u.id FROM {user_registered_for_group_sessions()} WHERE u.mail LIKE ?"
    cursor.execute(query, (mail,))
    registered_group_sessions = cursor.fetchall()
    
    if len(registered_group_sessions) < 1:
        print("You are not registered for any group sessions.")
        return
    print("Select your session to attend (q to exit):")

    while True:
        for i, session in enumerate(registered_group_sessions):
            print(f"{i + 1}: {session[2]} | Room: {session[1]} | {session[0]}")
        try:
            value = input("Session number: ")
            if value in {"exit", "Exit", "q", "Q"}:
                return
            index = int(value) - 1
            selected = registered_group_sessions[index]
        except:
            print("Not valid id.")
            print()
            continue;
        break

    while True:
        did_attend_str = input("Did attendant show up (y/n): ")
        if did_attend_str in {"yes", "y", "YES", "Yes", "Y"}:
            did_attend = True
            break
        elif did_attend_str in {"no", "n", "NO", "No", "N"}:
            did_attend = False
            break
        elif did_attend_str in {"exit", "Exit", "q", "Q"}:
            return
        print("Write yes or no.")
        print()

    insert_query = "INSERT INTO attended (showed_up, session_time, session_room, user_id) VALUES (?, ?, ?, ?)"
    try:
        cursor.execute(insert_query, (did_attend, selected[0], selected[1], selected[3],))
        con.commit()
        print("Success")
    except Exception as e:
        text = str(e)
        if text.startswith("UNIQUE"):
            print("Already attended this session.")
            return
        if "register_time < session_time" in text:
            print("Cannot register for session in the past.")
            return
        print(str(e), end=".\n")


def schedule():
    week_nr = 0
    day = 0
    
    while week_nr == 0:
        try:
            week_nr = int(input("week number: "))
            if week_nr < 1 or week_nr > 53:
                print("Week must be between 1 and 53")
                week_nr = 0
        except:
            print("Week number has to be a numeric value")

    while day == 0:
        try:
            day = int(input("Day number (1 is Monday, 7 is Sunday): "))
            if day < 1 or day > 7:
                print("Day must be between 1 and 7")
                day = 0
        except:
            print("Day number has to be a numeric value")
    
    start_date = date.fromisocalendar(date.today().year, week_nr, day)
    end_date = date.fromisocalendar(date.today().year, week_nr, 7)

    query = f"""SELECT activity, description, start_time, duration 
                FROM group_sessions 
                WHERE DATE(start_time) >= '{start_date}'
                AND DATE(start_time) <= '{end_date}'
                ORDER BY start_time ASC"""
    
    cursor.execute(query)
    group_sessions = cursor.fetchall()

    if len(group_sessions) < 1:
        print("No sessions found in this time interval")
        return

    for i, session in enumerate(group_sessions):
            print(f"{session[0]} | {session[1]} | {session[2]} | duration: {session[3]}")
    
    return  


def most_group_sessions():
    try:
        year_str = input("Year (2026, 2027, etc.): ")
        int(year_str)
        month_str = input("Month (1 = Jan, 2 = Feb, etc.): ")
        month = int(month_str)
    except Exception as _:
        print("Month and year must be a number.")
        return
    if month > 12 or month < 1:
        print("Month must be in the range 1 to 12 inclusive.")
        return

    month_name = calendar.month_name[month]
    if len(month_str) == 1:
        month_str = f"0{month_str}"

    subquery = f"SELECT COUNT(*) AS times, user_id, mail, first_name, last_name FROM {user_attendant_join()} WHERE showed_up = TRUE AND strftime('%m', session_time) = ? AND strftime('%Y', session_time) = ? GROUP BY mail"
    query = f"SELECT * FROM ({subquery}) WHERE times = ( SELECT MAX(times) FROM ({subquery}) )"

    cursor.execute(query, (month_str, year_str, month_str, year_str,))
    top_sessions_people = cursor.fetchall()

    if len(top_sessions_people) == 0:
        print(f"No people trained.")
        return

    print(f"Trained the most in {month_name}:")
    for person in top_sessions_people:
        print(f"{person[3]} {person[4]} has trained {person[0]} times.")

    


def help():
    print("""sitcli [COMMAND]

[COMMAND]:
    register
    attend
    schedule
    most-group-sessions
    help
""")


def main():
    argv = sys.argv

    if len(argv) < 2:
        help()
        sys.exit()

    command = argv[1]

    match command:
        case "register":
            register()
        case "attend":
            attend()
        case "most-group-sessions":
            most_group_sessions()
        case "schedule":
            schedule()
        case _:
            help()

if __name__ == "__main__":
    main()
    con.close()

