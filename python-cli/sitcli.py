#!/bin/env python

import sqlite3
import sys

def getUsers():

    print("Noe")

def noe():
    print("Noe")

def help():
    print("""sitcli [COMMAND]""")


def main():
    argv = sys.argv

    if len(argv) < 2:
        help()
        sys.exit()

    command = argv[1]

    match command:
        case "noe":
            noe()
        case "get users":
            noe()

if __name__ == "__main__":
    main()

