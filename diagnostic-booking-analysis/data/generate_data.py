import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

np.random.seed(99)
random.seed(99)

N = 20000

start_date = datetime(2023, 1, 1)
dates = [start_date + timedelta(seconds=random.randint(0, 365*24*3600)) for _ in range(N)]
dates.sort()

# Diagnostic test types with realistic weights
test_types = [
    'Complete Blood Count (CBC)',
    'Blood Sugar (Fasting)',
    'Lipid Profile',
    'Thyroid Profile (T3/T4/TSH)',
    'Liver Function Test (LFT)',
    'Kidney Function Test (KFT)',
    'Urine Routine',
    'ECG',
    'Chest X-Ray',
    'Full Body Checkup',
    'COVID RT-PCR',
    'Vitamin D & B12',
    'HbA1c (Diabetes)',
    'Dengue NS1 Antigen',
    'Pregnancy Test (Beta HCG)',
]
test_weights = [0.14, 0.12, 0.10, 0.09, 0.08, 0.07, 0.07, 0.06, 0.06, 0.05, 0.04, 0.04, 0.04, 0.03, 0.01]

# Test prices (INR)
test_prices = {
    'Complete Blood Count (CBC)':       350,
    'Blood Sugar (Fasting)':            120,
    'Lipid Profile':                    650,
    'Thyroid Profile (T3/T4/TSH)':      850,
    'Liver Function Test (LFT)':        750,
    'Kidney Function Test (KFT)':       700,
    'Urine Routine':                    150,
    'ECG':                              300,
    'Chest X-Ray':                      400,
    'Full Body Checkup':               2500,
    'COVID RT-PCR':                     500,
    'Vitamin D & B12':                  900,
    'HbA1c (Diabetes)':                 400,
    'Dengue NS1 Antigen':               600,
    'Pregnancy Test (Beta HCG)':        350,
}

# Diagnostic centers
centers = [
    'SRL Diagnostics - Thane',
    'Dr Lal PathLabs - Kharghar',
    'Metropolis - Vashi',
    'Thyrocare - Airoli',
    'Apollo Diagnostics - Belapur',
    'Suburban Diagnostics - Panvel',
]
center_weights = [0.22, 0.20, 0.18, 0.16, 0.14, 0.10]

# Cities
cities = ['Thane', 'Navi Mumbai', 'Kharghar', 'Vashi', 'Airoli', 'Belapur', 'Panvel', 'Nerul']
city_weights = [0.20, 0.18, 0.15, 0.13, 0.12, 0.10, 0.07, 0.05]

# Booking channels
channels = ['Mobile App', 'Website', 'Walk-In', 'Phone Call', 'Doctor Referral']
channel_weights = [0.35, 0.25, 0.20, 0.12, 0.08]

# Patient age groups
age_groups = ['18-25', '26-35', '36-45', '46-55', '56-65', '65+']
age_weights = [0.10, 0.20, 0.25, 0.22, 0.15, 0.08]

# Gender
genders = ['Male', 'Female']
gender_weights = [0.52, 0.48]

# Status
# Cancelled more in Walk-in, more success in app/web
statuses = ['Confirmed', 'Completed', 'Cancelled', 'No-Show']
status_weights = [0.15, 0.72, 0.08, 0.05]

# Generate data
booking_ids  = [f"BK{str(i).zfill(6)}" for i in range(1, N+1)]
patient_ids  = [f"PAT{str(random.randint(1, 8000)).zfill(5)}" for _ in range(N)]
test_list    = random.choices(test_types, weights=test_weights, k=N)
center_list  = random.choices(centers, weights=center_weights, k=N)
city_list    = random.choices(cities, weights=city_weights, k=N)
channel_list = random.choices(channels, weights=channel_weights, k=N)
age_list     = random.choices(age_groups, weights=age_weights, k=N)
gender_list  = random.choices(genders, weights=gender_weights, k=N)
status_list  = random.choices(statuses, weights=status_weights, k=N)

# Price with small random variation (+/- 10%)
prices = []
for test in test_list:
    base = test_prices[test]
    price = round(base * random.uniform(0.90, 1.10))
    prices.append(price)

# Revenue only for completed bookings
revenues = [p if s == 'Completed' else 0 for p, s in zip(prices, status_list)]

# Home collection flag (25% of bookings)
home_collection = [1 if random.random() < 0.25 else 0 for _ in range(N)]

# Report delivery time in hours (2-48 hours)
report_hours = []
for test in test_list:
    if test in ['COVID RT-PCR', 'Full Body Checkup', 'Thyroid Profile (T3/T4/TSH)']:
        report_hours.append(random.randint(12, 48))
    elif test in ['ECG', 'Chest X-Ray']:
        report_hours.append(random.randint(1, 4))
    else:
        report_hours.append(random.randint(4, 24))

df = pd.DataFrame({
    'booking_id':       booking_ids,
    'patient_id':       patient_ids,
    'booking_date':     [d.date() for d in dates],
    'booking_time':     [d.strftime('%H:%M') for d in dates],
    'test_type':        test_list,
    'test_price':       prices,
    'revenue':          revenues,
    'diagnostic_center':center_list,
    'city':             city_list,
    'booking_channel':  channel_list,
    'age_group':        age_list,
    'gender':           gender_list,
    'status':           status_list,
    'home_collection':  home_collection,
    'report_hours':     report_hours,
    'month':            [d.month for d in dates],
    'hour':             [d.hour for d in dates],
    'day_of_week':      [d.strftime('%A') for d in dates],
})

df.to_csv('/home/claude/diagnostic-booking-analysis/data/diagnostic_bookings.csv', index=False)
print(f"Dataset: {len(df):,} rows")
print(f"Completion rate: {(df['status']=='Completed').mean()*100:.1f}%")
print(f"Cancellation rate: {(df['status']=='Cancelled').mean()*100:.1f}%")
print(f"Total Revenue: ₹{df['revenue'].sum()/1e7:.2f} Cr")
print(df.head(3))
