#!/bin/env python

import sqlite3
import sys

con = sqlite3.connect("../database.db")
cursor = con.cursor()


def session_room_center_join():
    return "group_sessions AS g INNER JOIN rooms AS r ON (g.room_id = r.id) INNER JOIN centers AS c ON (r.center_id = c.id)"


def register():
    # username = input("Username: ")
    activity = input("Activity: ")
    # time = input("Time slot: ")

    query = f"SELECT * FROM {session_room_center_join()} WHERE g.activity LIKE ?"

    print(query)

    cursor.execute(query, (activity,))
    rows = cursor.fetchall()
    print(rows)


def help():
    print("""sitcli [COMMAND]""")


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

