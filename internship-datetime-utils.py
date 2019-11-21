from datetime import date, timedelta
import calendar 

# Get internship start date.
start_date = input("Internship start date: (dd-mm-yyyy) \n> ").strip()
# Convert to a list with numbers.
start_date = list(map(int, start_date.split("-")))
# Convert to a date.
start_date = date(start_date[2], start_date[1], start_date[0])

# Get the duration of the internship in hours.
hour_amount = input("Amount of hour required for the intership: \n> ").strip()
hour_amount = int(hour_amount)

# Get the amount of work hours a week.
week_hours = input("Amount of hours per week: \n> ").strip()
week_hours = int(week_hours)

# Calculate the amount of weeks.
weeks = hour_amount / week_hours

# Get extra weeks.
extra_weeks = input("Extra amount of weeks (leave empty for none): \n> ")

# Add extra weeks if necessary.
if extra_weeks:
    extra_weeks = int(extra_weeks)
    weeks = weeks + extra_weeks

# Calculate the end date.
end_date = start_date + timedelta(weeks=weeks)

# Set the day to monday if the calculated end date is in the weekend.
if end_date.weekday() > 4:
    # Add two days if saturday and add only one if sunday.
    monday_addition = 2 if end_date.weekday() == 5 else 1
    end_date = end_date + timedelta(days=monday_addition)

print()
print(end_date.strftime("End date: %d-%m-%Y"))