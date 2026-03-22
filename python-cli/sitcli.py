#!/bin/env python

import sqlite3
import sys

con = sqlite3.connect("../database.db")
cursor = con.cursor()


def session_room_center_join():
    return "group_sessions AS g INNER JOIN rooms AS r ON (g.room_id = r.id) INNER JOIN centers AS c ON (r.center_id = c.id)"


# Antagelse: Epost er brukernavn

def register():
    mail = "ola.normann@mail.no" # "johnny@stud.ntnu.no" # input("Mail: ")
    if "%" in mail:
        print("Not a valid mail.")
        return

    activity = "Spin%".replace("*", "%") # input("Activity (* for wildcard): ")

    year_and_date = "2026-03-19" # input("Year and date (YYYY-MM-DD): ")
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
            print(f"{i + 1}: {session[0]} {session[2]} mins {session[4]}")
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
        print(str(e))


def help():
    print("""sitcli [COMMAND]
[COMMAND]:
    register""")


def main():
    argv = sys.argv

    if len(argv) < 2:
        help()
        sys.exit()

    command = argv[1]

    match command:
        case "register":
            register()

if __name__ == "__main__":
    main()
    con.close()

