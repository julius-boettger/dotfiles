from datetime import datetime
import subprocess
import pickle
import os

today = datetime.now()
# monday = 0, sunday = 6
weekday = today.weekday()
is_saturday = weekday == 5

# end program if not saturday
if not is_saturday:
    print("not saturday, exiting...")
    exit()

# today is saturday!

# get directory this file is in
DIR = os.path.dirname(__file__)
# path to file to store date of last program run
LAST_RUN_DATE_FILE_PATH = DIR + "/last-run-date"

# try to load date of last program run from file
if os.path.exists(LAST_RUN_DATE_FILE_PATH):
    # rb = read binary
    with open(LAST_RUN_DATE_FILE_PATH, "rb") as file: last_run = pickle.load(file)
    # end program if it already ran today
    if today.date() == last_run.date():
        print("program already ran today, exiting...")
        exit()

# program has not run today! run it!

# save todays date to file as date of last run
# wb = write binary
with open(LAST_RUN_DATE_FILE_PATH, "wb") as file: pickle.dump(today, file)

# run program
print("running program...")
subprocess.run(f"alacritty --hold -e {DIR}/update.sh &", shell=True)
