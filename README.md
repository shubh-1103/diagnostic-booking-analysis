# 🏥 Diagnostic Test Booking System — Data Analysis

> **Data Analyst Portfolio Project** | Python • Pandas • Matplotlib • Seaborn • MySQL

---

## 🧾 Project Overview

End-to-end data analysis on **20,000 diagnostic test bookings** across Thane & Navi Mumbai in 2023.

This project extends a Java-based Diagnostic Booking System by adding a full data analytics layer — uncovering operational insights to reduce cancellations, maximize revenue, and improve patient experience across diagnostic centers.

**Key Skills Demonstrated:**
- Data wrangling & cleaning with Pandas
- Exploratory Data Analysis (EDA)
- KPI tracking and business reporting
- Cancellation root cause analysis
- Revenue segmentation
- MySQL queries for operational analytics

---

## 📁 Project Structure

```
diagnostic-booking-analysis/
├── data/
│   ├── diagnostic_bookings.csv     ← 20K row dataset (18 columns)
│   └── generate_data.py            ← Dataset generation script
├── notebooks/
│   └── analysis.ipynb              ← Full analysis (heavily commented)
├── sql/
│   └── queries.sql                 ← 16 MySQL queries
├── visuals/
│   ├── 01_monthly_bookings.png
│   ├── 02_test_type_analysis.png
│   ├── 03_peak_hour_heatmap.png
│   ├── 04_cancellation_analysis.png
│   ├── 05_revenue_analysis.png
│   └── 06_center_performance.png
└── README.md
```

---

## 📊 Dataset

| Column | Description |
|--------|-------------|
| `booking_id` | Unique booking ID |
| `patient_id` | Anonymized patient ID |
| `booking_date` | Date of booking |
| `booking_time` | Time of booking |
| `test_type` | Diagnostic test name (CBC, Lipid Profile, etc.) |
| `test_price` | Price in INR |
| `revenue` | Actual revenue (0 for cancelled/no-show) |
| `diagnostic_center` | Center name & location |
| `city` | Patient city |
| `booking_channel` | Mobile App / Website / Walk-In / Phone / Referral |
| `age_group` | Patient age group |
| `gender` | Male / Female |
| `status` | Completed / Confirmed / Cancelled / No-Show |
| `home_collection` | 1 if home sample collection requested |
| `report_hours` | Turnaround time in hours |

---

## 🔍 Analysis Sections

### 1. Monthly Trends
Booking volume and revenue growth throughout 2023, with completion rate tracking.

### 2. Test Type Analysis
Most popular tests by volume vs revenue — identifying high-value test opportunities.

### 3. Peak Hour Heatmap
When patients book appointments — critical for staffing and system capacity planning.

### 4. Cancellation & No-Show Analysis
Drop-off rates by booking channel and age group — with estimated revenue loss.

### 5. Revenue Analysis
Revenue breakdown by diagnostic center and booking channel.

### 6. Center Performance
Completion rate comparison across all centers + home collection demand by city.

---

## 📈 Key Findings

| Metric | Value |
|--------|-------|
| Total Bookings | 20,000 |
| Completion Rate | 72.0% |
| Cancellation Rate | 8.1% |
| No-Show Rate | 5.1% |
| Total Revenue | ₹84.25 Lakhs |
| Avg Booking Value | ₹584 |
| Home Collection Rate | 25.0% |
| Most Booked Test | Complete Blood Count (CBC) |
| Top Channel | Mobile App (35%) |
| Peak Booking Hour | 7:00 PM |

---

## 💡 Business Recommendations

1. **Reduce No-Shows** — Automated WhatsApp/SMS reminders 24hrs and 2hrs before appointment could recover ~₹8–10 Lakhs annually.

2. **Mobile-First Strategy** — Mobile App has the highest revenue and lowest drop-off rate. Prioritize app UX improvements over other channels.

3. **Evening Staffing** — Peak bookings at 7PM–9PM. Customer support and home collection teams must be available in this window.

4. **High-Value Test Bundles** — Full Body Checkup and Thyroid Profile have highest revenue per booking. Preventive health packages could increase average ticket size by 20–30%.

5. **Home Collection Expansion** — 25% of patients prefer home collection. Expanding fleet in Thane and Navi Mumbai would reduce walk-in no-shows significantly.

---

## 🛠️ How to Run

```bash
# 1. Clone the repo
git clone https://github.com/shubh-1103/diagnostic-booking-analysis.git
cd diagnostic-booking-analysis

# 2. Install dependencies
pip install pandas numpy matplotlib seaborn jupyter

# 3. Regenerate dataset (optional)
python data/generate_data.py

# 4. Open notebook
jupyter notebook notebooks/analysis.ipynb
```

---

## 🔗 Related Project

This project is part of a two-project fintech/health-tech data portfolio:
- **UPI / Fintech Transaction Analysis** → [github.com/shubh-1103/upi-fintech-analysis](https://github.com/shubh-1103/upi-fintech-analysis)

---

## 👤 Author

**Shubham Jadhav**
📧 shubhamjadhav2115@gmail.com
📍 Thane, Navi Mumbai
🔗 [GitHub](https://github.com/shubh-1103) | [LinkedIn](#)

---

*Dataset is synthetically generated to mirror real-world diagnostic booking patterns for portfolio demonstration purposes.*
