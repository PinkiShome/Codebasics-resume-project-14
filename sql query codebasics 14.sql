-- Question 1. Total Users & Growth Trends 
-- What is the total number of users for LioCinema and Jotstar, and how do they compare in terms of growth trends (January–November 2024)? 

-- Step 1: Get the total number of unique users for each platform
SELECT 
    'Jotstar' AS platform, COUNT(DISTINCT user_id) AS total_users
FROM jotstar_db.subscribers
UNION ALL
SELECT 
    'LioCinema' AS platform, COUNT(DISTINCT user_id) AS total_users
FROM liocinema_db.subscribers;

-- Step 2: Monthly user growth trend (Jan–Nov 2024) for both platforms
SELECT 
    platform,
    COUNT(DISTINCT CASE WHEN MONTH(subscription_date) = 1 THEN user_id END) AS Jan,
    COUNT(DISTINCT CASE WHEN MONTH(subscription_date) = 2 THEN user_id END) AS Feb,
    COUNT(DISTINCT CASE WHEN MONTH(subscription_date) = 3 THEN user_id END) AS Mar,
    COUNT(DISTINCT CASE WHEN MONTH(subscription_date) = 4 THEN user_id END) AS Apr,
    COUNT(DISTINCT CASE WHEN MONTH(subscription_date) = 5 THEN user_id END) AS May,
    COUNT(DISTINCT CASE WHEN MONTH(subscription_date) = 6 THEN user_id END) AS Jun,
    COUNT(DISTINCT CASE WHEN MONTH(subscription_date) = 7 THEN user_id END) AS Jul,
    COUNT(DISTINCT CASE WHEN MONTH(subscription_date) = 8 THEN user_id END) AS Aug,
    COUNT(DISTINCT CASE WHEN MONTH(subscription_date) = 9 THEN user_id END) AS Sep,
    COUNT(DISTINCT CASE WHEN MONTH(subscription_date) = 10 THEN user_id END) AS Oct,
    COUNT(DISTINCT CASE WHEN MONTH(subscription_date) = 11 THEN user_id END) AS Nov
FROM (
    SELECT 'Jotstar' AS platform, user_id, subscription_date 
    FROM jotstar_db.subscribers
    WHERE YEAR(subscription_date) = 2024
    UNION ALL
    SELECT 'LioCinema' AS platform, user_id, subscription_date 
    FROM liocinema_db.subscribers
    WHERE YEAR(subscription_date) = 2024
) AS combined_users
WHERE MONTH(subscription_date) BETWEEN 1 AND 11
GROUP BY platform;
-- Question 2.Content Library Comparison
-- What is the total number of contents available on LioCinema vs. Jotstar? How do they differ in terms of language and content type?
-- Total Number of Contents on Each Platform
SELECT 
    'Jotstar' AS platform, COUNT(*) AS total_contents
FROM jotstar_db.contents
UNION ALL
SELECT 
    'LioCinema' AS platform, COUNT(*) AS total_contents
FROM liocinema_db.contents;
-- Content Distribution by Language
SELECT 
    platform, 
    language, 
    COUNT(*) AS content_count
FROM (
    SELECT 'Jotstar' AS platform, language FROM jotstar_db.contents
    UNION ALL
    SELECT 'LioCinema' AS platform, language FROM liocinema_db.contents
) AS combined_contents
GROUP BY platform, language
ORDER BY platform, content_count DESC;
-- Content Distribution by Content Type
SELECT 
    platform, 
    content_type, 
    COUNT(*) AS content_count
FROM (
    SELECT 'Jotstar' AS platform, content_type FROM jotstar_db.contents
    UNION ALL
    SELECT 'LioCinema' AS platform, content_type FROM liocinema_db.contents
) AS combined_contents
GROUP BY platform, content_type
ORDER BY platform, content_count DESC;
-- 3. User Demographics
-- What is the distribution of users by age group, city tier, and subscription plan for each platform?
-- Distribution of Users by Age Group
SELECT 
    platform, 
    age_group, 
    COUNT(*) AS user_count
FROM (
    SELECT 'Jotstar' AS platform, age_group FROM jotstar_db.subscribers
    UNION ALL
    SELECT 'LioCinema' AS platform, age_group FROM liocinema_db.subscribers
) AS combined_users
GROUP BY platform, age_group
ORDER BY platform, user_count DESC;
-- Distribution of Users by City Tier
SELECT 
    platform, 
    city_tier, 
    COUNT(*) AS user_count
FROM (
    SELECT 'Jotstar' AS platform, city_tier FROM jotstar_db.subscribers
    UNION ALL
    SELECT 'LioCinema' AS platform, city_tier FROM liocinema_db.subscribers
) AS combined_users
GROUP BY platform, city_tier
ORDER BY platform, user_count DESC;
--  Distribution of Users by Subscription Plan
SELECT 
    platform, 
    subscription_plan, 
    COUNT(*) AS user_count
FROM (
    SELECT 'Jotstar' AS platform, subscription_plan FROM jotstar_db.subscribers
    UNION ALL
    SELECT 'LioCinema' AS platform, subscription_plan FROM liocinema_db.subscribers
) AS combined_users
GROUP BY platform, subscription_plan
ORDER BY platform, user_count DESC;
-- 4. Active vs. Inactive Users
-- What percentage of LioCinema and Jotstar users are active vs. inactive? How do these rates vary by age group and subscription plan?
SELECT 
    platform,
    ROUND(SUM(CASE 
            WHEN last_active_date IS NOT NULL 
            AND last_active_date >= subscription_date
            THEN 1 ELSE 0 
        END) * 100.0 / COUNT(*), 2) AS active_percentage,
    ROUND(SUM(CASE 
            WHEN last_active_date IS NULL 
            THEN 1 ELSE 0 
        END) * 100.0 / COUNT(*), 2) AS inactive_percentage
FROM (
    SELECT 'Jotstar' AS platform, user_id, subscription_date, last_active_date FROM jotstar_db.subscribers
    UNION ALL
    SELECT 'LioCinema' AS platform, user_id, subscription_date, last_active_date FROM liocinema_db.subscribers
) AS combined_users
GROUP BY platform;
--  Active vs. Inactive Users by Age Group
SELECT 
    platform,
    age_group,
    ROUND(SUM(CASE 
            WHEN last_active_date IS NOT NULL 
            AND last_active_date >= subscription_date
            THEN 1 ELSE 0 
        END) * 100.0 / COUNT(*), 2) AS active_percentage,
    ROUND(SUM(CASE 
            WHEN last_active_date IS NULL 
            THEN 1 ELSE 0 
        END) * 100.0 / COUNT(*), 2) AS inactive_percentage
FROM (
    SELECT 'Jotstar' AS platform, user_id, age_group, subscription_date, last_active_date FROM jotstar_db.subscribers
    UNION ALL
    SELECT 'LioCinema' AS platform, user_id, age_group, subscription_date, last_active_date FROM liocinema_db.subscribers
) AS combined_users
GROUP BY platform, age_group
ORDER BY platform, active_percentage DESC;
-- Active vs. Inactive Users by Subscription Plan
 SELECT 
    platform, subscription_plan,
 ROUND(SUM(CASE 
            WHEN last_active_date IS NOT NULL 
            AND last_active_date >= subscription_date
            THEN 1 ELSE 0 
        END) * 100.0 / COUNT(*), 2) AS active_percentage,
    ROUND(SUM(CASE 
            WHEN last_active_date IS NULL 
            THEN 1 ELSE 0 
        END) * 100.0 / COUNT(*), 2) AS inactive_percentage
FROM (
    SELECT 'Jotstar' AS platform, user_id, subscription_plan, subscription_date, last_active_date FROM jotstar_db.subscribers
    UNION ALL
    SELECT 'LioCinema' AS platform, user_id, subscription_plan, subscription_date, last_active_date FROM liocinema_db.subscribers
) AS combined_users
GROUP BY platform, subscription_plan
ORDER BY platform, active_percentage DESC;
-- 5. Watch Time Analysis
-- What is the average watch time for LioCinema vs. Jotstar during the analysis period? How do these compare by city tier and device type?
--  Average Watch Time for LioCinema vs. Jotstar
SELECT 
    platform, 
      ROUND(COALESCE(AVG(total_watch_time_mins), 0), 2) AS avg_watch_time_mins
FROM (
    SELECT 'Jotstar' AS platform, user_id, total_watch_time_mins FROM jotstar_db.content_consumption
    UNION ALL
    SELECT 'LioCinema' AS platform, user_id, total_watch_time_mins FROM liocinema_db.content_consumption
) AS combined_watch_time
GROUP BY platform;
--  Average Watch Time by City Tier
SELECT 
    platform, 
    city_tier, 
  ROUND(COALESCE(AVG(total_watch_time_mins), 0), 2) AS avg_watch_time_mins
FROM (
    SELECT 'Jotstar' AS platform, s.city_tier, c.total_watch_time_mins 
    FROM jotstar_db.content_consumption c
    JOIN jotstar_db.subscribers s ON c.user_id = s.user_id
    UNION ALL
    SELECT 'LioCinema' AS platform, s.city_tier, c.total_watch_time_mins 
    FROM liocinema_db.content_consumption c
    JOIN liocinema_db.subscribers s ON c.user_id = s.user_id
) AS combined_watch_time
GROUP BY platform, city_tier
ORDER BY platform, avg_watch_time_mins DESC;
--  Average Watch Time by Device Type
SELECT 
    platform, 
    device_type, 
    ROUND(COALESCE(AVG(total_watch_time_mins)/60, 0), 2) AS avg_watch_time_hrs
FROM (
    SELECT 'Jotstar' AS platform, device_type, total_watch_time_mins FROM jotstar_db.content_consumption
    UNION ALL
    SELECT 'LioCinema' AS platform, device_type, total_watch_time_mins FROM liocinema_db.content_consumption
) AS combined_watch_time
GROUP BY platform, device_type
ORDER BY platform, avg_watch_time_hrs DESC;
-- 6. Inactivity Correlation
-- How do inactivity patterns correlate with total watch time or average watch time? Are less engaged users more likely to become inactive?
WITH user_activity AS (
    -- Combine data from both platforms
    SELECT 
        'Jotstar' AS platform, 
        s.user_id, 
        s.last_active_date, 
        c.total_watch_time_mins, 
        DATEDIFF(CURDATE(), s.last_active_date) AS days_since_active
    FROM jotstar_db.subscribers s
    LEFT JOIN jotstar_db.content_consumption c ON s.user_id = c.user_id

    UNION ALL

    SELECT 
        'LioCinema' AS platform, 
        s.user_id, 
        s.last_active_date, 
        c.total_watch_time_mins, 
        DATEDIFF(CURDATE(), s.last_active_date) AS days_since_active
    FROM liocinema_db.subscribers s
    LEFT JOIN liocinema_db.content_consumption c ON s.user_id = c.user_id
)

-- Classify users as Active or Inactive and analyze watch time patterns
SELECT 
    platform,
    CASE 
        WHEN days_since_active > 90 THEN 'Inactive'
        ELSE 'Active'
    END AS user_status,
    COUNT(user_id) AS user_count,
	ROUND(AVG(COALESCE(total_watch_time_mins, 0) / 60), 2) AS avg_watch_time_hrs,
	ROUND(SUM(COALESCE(total_watch_time_mins, 0) / (60*24)), 2) AS total_watch_time_days
FROM user_activity
GROUP BY platform, user_status
ORDER BY platform, user_status;
-- 	From result it is obvious that less engaged users more likely to become inactive.
-- 7. Downgrade Trends
-- How do downgrade trends differ between LioCinema and Jotstar? Are downgrades more prevalent on one platform compared to the other?
-- select distinct subscription_plan
 -- from subscribers;
WITH downgrade_analysis AS (
    SELECT 
        'Jotstar' AS platform,
        user_id, 
        subscription_plan AS previous_plan, 
        new_subscription_plan AS current_plan,
        CASE 
            WHEN new_subscription_plan = 'VIP' and subscription_plan = 'FREE'  THEN 'Upgraded'
             WHEN new_subscription_plan = 'PREMIUM' and subscription_plan = 'FREE'  THEN 'Upgraded'
              WHEN new_subscription_plan = 'PREMIUM' and subscription_plan = 'VIP'  THEN 'Upgraded'
               WHEN new_subscription_plan = 'FREE' and subscription_plan = 'VIP'  THEN 'Downgraded'
             WHEN new_subscription_plan = 'FREE' and subscription_plan = 'PREMIUM'  THEN 'Downgraded'
              WHEN new_subscription_plan = 'VIP' and subscription_plan = 'PREMIUM'  THEN 'Downgraded'
            ELSE 'No Change'
        END AS change_status
    FROM jotstar_db.subscribers
    WHERE new_subscription_plan IS NOT NULL 

    UNION ALL

    SELECT 
        'LioCinema' AS platform,
        user_id, 
        subscription_plan AS previous_plan, 
        new_subscription_plan AS current_plan,
        CASE 
             WHEN new_subscription_plan = 'Basic' and subscription_plan = 'FREE'  THEN 'Upgraded'
             WHEN new_subscription_plan = 'PREMIUM' and subscription_plan = 'Basic'  THEN 'Upgraded'
              WHEN new_subscription_plan = 'Premium' and subscription_plan = 'Free'  THEN 'Upgraded'
               WHEN new_subscription_plan = 'FREE' and subscription_plan = 'Basic'  THEN 'Downgraded'
             WHEN new_subscription_plan = 'FREE' and subscription_plan = 'PREMIUM'  THEN 'Downgraded'
              WHEN new_subscription_plan = 'Basic' and subscription_plan = 'Premium'  THEN 'Downgraded'
            ELSE 'No Change'
        END AS change_status
    FROM liocinema_db.subscribers
    WHERE new_subscription_plan IS NOT NULL
)

-- Aggregate results by platform
SELECT 
    platform, 
    change_status, 
    COUNT(user_id) AS user_count,
    ROUND(100.0 * COUNT(user_id) / SUM(COUNT(user_id)) OVER (PARTITION BY platform), 2) AS percentage
FROM downgrade_analysis
GROUP BY platform, change_status
ORDER BY platform, percentage DESC;
-- 8. Upgrade Patterns
-- What are the most common upgrade transitions (e.g., Free to Basic, Free to VIP, Free to Premium) for LioCinema and Jotstar? How do these differ across platforms?
WITH upgrade_analysis AS (
    SELECT 
        'Jotstar' AS platform,
        user_id, 
        subscription_plan AS previous_plan, 
        new_subscription_plan AS current_plan,
        CASE 
            WHEN new_subscription_plan = 'VIP' and subscription_plan = 'FREE'  THEN 'Upgraded'
             WHEN new_subscription_plan = 'PREMIUM' and subscription_plan = 'FREE'  THEN 'Upgraded'
              WHEN new_subscription_plan = 'PREMIUM' and subscription_plan = 'VIP'  THEN 'Upgraded'
               WHEN new_subscription_plan = 'FREE' and subscription_plan = 'VIP'  THEN 'Downgraded'
             WHEN new_subscription_plan = 'FREE' and subscription_plan = 'PREMIUM'  THEN 'Downgraded'
              WHEN new_subscription_plan = 'VIP' and subscription_plan = 'PREMIUM'  THEN 'Downgraded'
            ELSE 'No Change'
        END AS change_status
    FROM jotstar_db.subscribers
    WHERE new_subscription_plan IS NOT NULL 

    UNION ALL

    SELECT 
        'LioCinema' AS platform,
        user_id, 
        subscription_plan AS previous_plan, 
        new_subscription_plan AS current_plan,
        CASE 
            WHEN new_subscription_plan = 'Basic' and subscription_plan = 'FREE'  THEN 'Upgraded'
             WHEN new_subscription_plan = 'PREMIUM' and subscription_plan = 'Basic'  THEN 'Upgraded'
              WHEN new_subscription_plan = 'Premium' and subscription_plan = 'Free'  THEN 'Upgraded'
               WHEN new_subscription_plan = 'FREE' and subscription_plan = 'Basic'  THEN 'Downgraded'
             WHEN new_subscription_plan = 'FREE' and subscription_plan = 'PREMIUM'  THEN 'Downgraded'
              WHEN new_subscription_plan = 'Basic' and subscription_plan = 'Premium'  THEN 'Downgraded'
            ELSE 'No Change'
        END AS change_status
    FROM liocinema_db.subscribers
    WHERE new_subscription_plan IS NOT NULL
)

-- Count upgrade transitions for each platform
SELECT 
    platform, 
    previous_plan, 
    current_plan, 
    COUNT(user_id) AS transition_count,
    ROUND(100.0 * COUNT(user_id) / SUM(COUNT(user_id)) OVER (PARTITION BY platform), 2) AS percentage
FROM upgrade_analysis
WHERE change_status = 'Upgraded'
GROUP BY platform, previous_plan, current_plan
ORDER BY platform, transition_count DESC;
-- 9. Paid Users Distribution
-- How does the paid user percentage (e.g., Basic, Premium for LioCinema; VIP, Premium for Jotstar) vary across different platforms? Analyse the proportion of premium users in Tier 1, Tier 2, and Tier 3 cities and identify any notable trends or differences.
WITH user_payment_status AS (
    SELECT 
        'Jotstar' AS platform,
        user_id,
        city_tier,
        subscription_plan,
        CASE 
            WHEN subscription_plan IN ('VIP', 'Premium') THEN 'Paid'
            ELSE 'Free'
        END AS user_type
    FROM jotstar_db.subscribers

    UNION ALL

    SELECT 
        'LioCinema' AS platform,
        user_id,
        city_tier,
        subscription_plan,
        CASE 
            WHEN subscription_plan IN ('Basic', 'Premium') THEN 'Paid'
            ELSE 'Free'
        END AS user_type
    FROM liocinema_db.subscribers
)

SELECT 
    platform, 
    user_type, 
    COUNT(user_id) AS user_count,
    ROUND(100.0 * COUNT(user_id) / SUM(COUNT(user_id)) OVER (PARTITION BY platform), 2) AS percentage
FROM user_payment_status
GROUP BY platform, user_type
ORDER BY platform, percentage DESC;
-- Premium User Distribution by City Tier
WITH premium_users AS (
    SELECT 
        'Jotstar' AS platform,
        city_tier,
        user_id
    FROM jotstar_db.subscribers
    WHERE subscription_plan = 'Premium'

    UNION ALL

    SELECT 
        'LioCinema' AS platform,
        city_tier,
        user_id
    FROM liocinema_db.subscribers
    WHERE subscription_plan = 'Premium'
)

SELECT 
    platform, 
    city_tier, 
    COUNT(user_id) AS premium_user_count,
    ROUND(100.0 * COUNT(user_id) / SUM(COUNT(user_id)) OVER (PARTITION BY platform), 2) AS percentage
FROM premium_users
GROUP BY platform, city_tier
ORDER BY platform, percentage DESC;
-- 10. Revenue Analysis ● Assume the following monthly subscription prices, calculate the total revenue generated by both platforms (LioCinema and Jotstar) for the analysis period (January to November 2024).
-- LioCinema Basic- Rs 69, Premium- Rs 129
-- Jotstar VIP- Rs 159, Premium- Rs 359
-- The calculation should consider: ❖ Subscribers count under each plan. ❖ Active duration of subscribers on their respective plans. ❖ Upgrades and downgrades during the period, ensuring revenue reflects the time spent under each plan. 
--  Revenue Calculation
WITH active_subscription_duration AS (
    SELECT 
        'Jotstar' AS platform,
        user_id,
        subscription_plan AS initial_plan,
        new_subscription_plan AS changed_plan,
        subscription_date,
        plan_change_date,
        TIMESTAMPDIFF(MONTH, subscription_date, 
            COALESCE(plan_change_date, '2024-11-30')) AS initial_active_months,
        TIMESTAMPDIFF(MONTH, plan_change_date, '2024-11-30') AS changed_active_months
    FROM jotstar_db.subscribers
    WHERE subscription_date BETWEEN '2024-01-01' AND '2024-11-30'

    UNION ALL

    SELECT 
        'LioCinema' AS platform,
        user_id,
        subscription_plan AS initial_plan,
        new_subscription_plan AS changed_plan,
        subscription_date,
        plan_change_date,
        TIMESTAMPDIFF(MONTH, subscription_date, 
            COALESCE(plan_change_date, '2024-11-30')) AS initial_active_months,
        TIMESTAMPDIFF(MONTH, plan_change_date, '2024-11-30') AS changed_active_months
    FROM liocinema_db.subscribers
    WHERE subscription_date BETWEEN '2024-01-01' AND '2024-11-30'
)

SELECT 
    a.platform,
    a.initial_plan AS old_subscription_plan,
    a.changed_plan AS new_subscription_plan,
    COUNT(DISTINCT a.user_id) AS total_users,
    SUM(
        CASE 
            WHEN a.plan_change_date IS NULL 
                THEN a.initial_active_months * IFNULL(p1.price, 0) -- Revenue for users who didn't change plans
            ELSE 
                (a.initial_active_months * IFNULL(p1.price, 0) + a.changed_active_months * IFNULL(p2.price, 0))
         END
    ) AS total_revenue
FROM active_subscription_duration a
LEFT JOIN (
    SELECT 'LioCinema' AS platform, 'Basic' AS subscription_plan, 69 AS price
    UNION ALL
    SELECT 'LioCinema', 'Premium', 129
    UNION ALL
    SELECT 'Jotstar', 'VIP', 159
    UNION ALL
    SELECT 'Jotstar', 'Premium', 359
) p1 
ON a.platform = p1.platform AND a.initial_plan = p1.subscription_plan
LEFT JOIN (
    SELECT 'LioCinema' AS platform, 'Basic' AS subscription_plan, 69 AS price
    UNION ALL
    SELECT 'LioCinema', 'Premium', 129
    UNION ALL
    SELECT 'Jotstar', 'VIP', 159
    UNION ALL
    SELECT 'Jotstar', 'Premium', 359
) p2 
ON a.platform = p2.platform AND a.changed_plan = p2.subscription_plan
GROUP BY a.platform, a.initial_plan, a.changed_plan
ORDER BY a.platform, total_revenue DESC;