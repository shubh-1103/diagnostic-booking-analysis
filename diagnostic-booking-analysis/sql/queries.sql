-- ============================================================
-- Diagnostic Test Booking System — SQL Queries
-- Author: Shubham Jadhav
-- Database: MySQL
-- ============================================================

-- ── CREATE TABLE ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS diagnostic_bookings (
    booking_id          VARCHAR(10)    PRIMARY KEY,
    patient_id          VARCHAR(10)    NOT NULL,
    booking_date        DATE           NOT NULL,
    booking_time        TIME           NOT NULL,
    test_type           VARCHAR(60)    NOT NULL,
    test_price          DECIMAL(10,2)  NOT NULL,
    revenue             DECIMAL(10,2)  DEFAULT 0,
    diagnostic_center   VARCHAR(60)    NOT NULL,
    city                VARCHAR(30)    NOT NULL,
    booking_channel     VARCHAR(20)    NOT NULL,
    age_group           VARCHAR(10)    NOT NULL,
    gender              VARCHAR(10)    NOT NULL,
    status              VARCHAR(15)    NOT NULL,
    home_collection     TINYINT(1)     DEFAULT 0,
    report_hours        INT,
    month               INT,
    hour                INT,
    day_of_week         VARCHAR(12)
);


-- ════════════════════════════════════════════════════════════
-- SECTION 1: OVERVIEW & KPIs
-- ════════════════════════════════════════════════════════════

-- Q1: Core KPIs dashboard
SELECT
    COUNT(*)                                                            AS total_bookings,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END)              AS completed,
    SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END)              AS cancelled,
    SUM(CASE WHEN status = 'No-Show'   THEN 1 ELSE 0 END)              AS no_show,
    ROUND(SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS completion_rate_pct,
    ROUND(SUM(revenue), 2)                                              AS total_revenue,
    ROUND(AVG(test_price), 2)                                           AS avg_booking_value,
    SUM(home_collection)                                                AS home_collection_bookings
FROM diagnostic_bookings;


-- Q2: Booking status breakdown with revenue impact
SELECT
    status,
    COUNT(*)                        AS booking_count,
    ROUND(SUM(test_price), 2)       AS potential_revenue,
    ROUND(SUM(revenue), 2)          AS actual_revenue,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM diagnostic_bookings), 2) AS pct_of_total
FROM diagnostic_bookings
GROUP BY status
ORDER BY booking_count DESC;


-- ════════════════════════════════════════════════════════════
-- SECTION 2: MONTHLY TRENDS
-- ════════════════════════════════════════════════════════════

-- Q3: Monthly booking volume and revenue
SELECT
    month,
    COUNT(*)                                                                    AS total_bookings,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END)                      AS completed,
    ROUND(SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS completion_rate_pct,
    ROUND(SUM(revenue), 2)                                                      AS monthly_revenue,
    ROUND(AVG(test_price), 2)                                                   AS avg_ticket
FROM diagnostic_bookings
GROUP BY month
ORDER BY month;


-- Q4: Month-over-month growth
SELECT
    curr.month,
    curr.bookings                                                               AS current_bookings,
    prev.bookings                                                               AS prev_bookings,
    ROUND((curr.bookings - prev.bookings) * 100.0 / prev.bookings, 2)          AS mom_growth_pct
FROM (
    SELECT month, COUNT(*) AS bookings FROM diagnostic_bookings GROUP BY month
) curr
LEFT JOIN (
    SELECT month, COUNT(*) AS bookings FROM diagnostic_bookings GROUP BY month
) prev ON curr.month = prev.month + 1
ORDER BY curr.month;


-- ════════════════════════════════════════════════════════════
-- SECTION 3: TEST TYPE ANALYSIS
-- ════════════════════════════════════════════════════════════

-- Q5: Most popular tests by volume and revenue
SELECT
    test_type,
    COUNT(*)                        AS total_bookings,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed,
    ROUND(SUM(revenue), 2)          AS total_revenue,
    ROUND(AVG(test_price), 2)       AS avg_price,
    ROUND(AVG(report_hours), 1)     AS avg_report_hours
FROM diagnostic_bookings
GROUP BY test_type
ORDER BY total_bookings DESC;


-- Q6: High-value test identification (revenue per booking)
SELECT
    test_type,
    ROUND(AVG(test_price), 2)       AS avg_price,
    ROUND(SUM(revenue), 2)          AS total_revenue,
    COUNT(*)                        AS bookings,
    ROUND(SUM(revenue) / NULLIF(COUNT(*), 0), 2) AS revenue_per_booking
FROM diagnostic_bookings
WHERE status = 'Completed'
GROUP BY test_type
ORDER BY revenue_per_booking DESC;


-- ════════════════════════════════════════════════════════════
-- SECTION 4: CANCELLATION ANALYSIS
-- ════════════════════════════════════════════════════════════

-- Q7: Drop-off rate by booking channel
SELECT
    booking_channel,
    COUNT(*)                                                                        AS total_bookings,
    SUM(CASE WHEN status IN ('Cancelled','No-Show') THEN 1 ELSE 0 END)             AS dropoffs,
    ROUND(SUM(CASE WHEN status IN ('Cancelled','No-Show') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS dropoff_rate_pct,
    ROUND(SUM(CASE WHEN status IN ('Cancelled','No-Show') THEN test_price ELSE 0 END), 2) AS lost_revenue
FROM diagnostic_bookings
GROUP BY booking_channel
ORDER BY dropoff_rate_pct DESC;


-- Q8: Drop-off rate by age group
SELECT
    age_group,
    COUNT(*)                                                                        AS total,
    SUM(CASE WHEN status IN ('Cancelled','No-Show') THEN 1 ELSE 0 END)             AS dropoffs,
    ROUND(SUM(CASE WHEN status IN ('Cancelled','No-Show') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS dropoff_rate_pct
FROM diagnostic_bookings
GROUP BY age_group
ORDER BY FIELD(age_group, '18-25','26-35','36-45','46-55','56-65','65+');


-- Q9: Total revenue lost to cancellations and no-shows
SELECT
    ROUND(SUM(test_price), 2)   AS total_lost_revenue,
    COUNT(*)                    AS total_dropoffs,
    ROUND(AVG(test_price), 2)   AS avg_lost_per_booking
FROM diagnostic_bookings
WHERE status IN ('Cancelled', 'No-Show');


-- ════════════════════════════════════════════════════════════
-- SECTION 5: CENTER PERFORMANCE
-- ════════════════════════════════════════════════════════════

-- Q10: Diagnostic center performance scorecard
SELECT
    diagnostic_center,
    COUNT(*)                                                                            AS total_bookings,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END)                              AS completed,
    ROUND(SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS completion_rate_pct,
    ROUND(SUM(revenue), 2)                                                              AS total_revenue,
    ROUND(AVG(test_price), 2)                                                           AS avg_ticket,
    SUM(home_collection)                                                                AS home_collection_count
FROM diagnostic_bookings
GROUP BY diagnostic_center
ORDER BY total_revenue DESC;


-- Q11: Best performing center by completion rate
SELECT
    diagnostic_center,
    ROUND(SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS completion_rate_pct,
    COUNT(*) AS total_bookings
FROM diagnostic_bookings
GROUP BY diagnostic_center
ORDER BY completion_rate_pct DESC
LIMIT 1;


-- ════════════════════════════════════════════════════════════
-- SECTION 6: PEAK HOUR & TIME ANALYSIS
-- ════════════════════════════════════════════════════════════

-- Q12: Bookings by hour of day
SELECT
    hour,
    COUNT(*)                        AS booking_count,
    ROUND(SUM(revenue), 2)          AS revenue
FROM diagnostic_bookings
GROUP BY hour
ORDER BY hour;


-- Q13: Busiest day of week
SELECT
    day_of_week,
    COUNT(*)                        AS booking_count,
    ROUND(SUM(revenue), 2)          AS revenue,
    ROUND(AVG(test_price), 2)       AS avg_ticket
FROM diagnostic_bookings
GROUP BY day_of_week
ORDER BY booking_count DESC;


-- ════════════════════════════════════════════════════════════
-- SECTION 7: HOME COLLECTION & CITY ANALYSIS
-- ════════════════════════════════════════════════════════════

-- Q14: Home collection demand by city
SELECT
    city,
    COUNT(*)                                                                    AS total_bookings,
    SUM(home_collection)                                                        AS home_collection_count,
    ROUND(SUM(home_collection) * 100.0 / COUNT(*), 2)                          AS home_collection_pct,
    ROUND(SUM(revenue), 2)                                                      AS total_revenue
FROM diagnostic_bookings
GROUP BY city
ORDER BY home_collection_pct DESC;


-- Q15: Patient demographics analysis
SELECT
    gender,
    age_group,
    COUNT(*)                        AS bookings,
    ROUND(AVG(test_price), 2)       AS avg_spend,
    ROUND(SUM(revenue), 2)          AS total_revenue
FROM diagnostic_bookings
WHERE status = 'Completed'
GROUP BY gender, age_group
ORDER BY gender, FIELD(age_group, '18-25','26-35','36-45','46-55','56-65','65+');


-- Q16: Report turnaround time by test category
SELECT
    test_type,
    ROUND(AVG(report_hours), 1)     AS avg_report_hours,
    MIN(report_hours)               AS fastest_hrs,
    MAX(report_hours)               AS slowest_hrs
FROM diagnostic_bookings
WHERE status = 'Completed'
GROUP BY test_type
ORDER BY avg_report_hours DESC;
