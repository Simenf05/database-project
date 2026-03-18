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
        exit()

    activity = "Spinning" # input("Activity: ")
    year_and_date = "2026-10-12" # input("Year and date (YYYY-MM-DD): ")

    query = f"SELECT time(start_time), room_id, duration, start_time FROM {session_room_center_join()} WHERE g.activity LIKE ? AND date(g.start_time) = ?"

    cursor.execute(query, (activity, year_and_date,))
    sessions_at_date = cursor.fetchall()

    print("Select your session:")

    while True:
        for i, session in enumerate(sessions_at_date):
            print(f"{i + 1}: {session}")
        try:
            index = int(input()) - 1
            selected = sessions_at_date[index]
        except:
            continue;
        break

    query = "SELECT id FROM users WHERE mail LIKE ?"
    cursor.execute(query, (mail,))
    user_id = cursor.fetchone()

    insert_query = "INSERT INTO registered (session_time, session_room, user_id) VALUES (?, ?, ?)"
    cursor.execute(insert_query, (selected[3], selected[1], user_id[0],))
    print("Success")


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

