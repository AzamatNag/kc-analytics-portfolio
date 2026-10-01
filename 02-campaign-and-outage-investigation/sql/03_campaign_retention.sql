-- Retention когорты кампании (13.08) и обычной когорты (06.08) по источникам, в %
SELECT r.cohort AS cohort,
       r.day_number AS day_number,
       r.active_users AS active_users,
       c.cohort_size AS cohort_size,
       round(r.active_users / c.cohort_size * 100, 1) AS retention_pct
FROM (
    SELECT concat(toString(u.first_day), ' ', u.source) AS cohort,
           dateDiff('day', u.first_day, a.day) AS day_number,
           uniqExact(u.user_id) AS active_users
    FROM (
        SELECT user_id, min(toDate(time)) AS first_day, any(source) AS source
        FROM simulator_20260820.feed_actions
        GROUP BY user_id
        HAVING first_day IN (toDate('2026-08-06'), toDate('2026-08-13'))
    ) u
    JOIN (
        SELECT DISTINCT user_id, toDate(time) AS day
        FROM simulator_20260820.feed_actions
        WHERE toDate(time) >= toDate('2026-08-06') AND toDate(time) < today()
    ) a ON u.user_id = a.user_id
    GROUP BY cohort, day_number
) r
JOIN (
    SELECT concat(toString(first_day), ' ', source) AS cohort, count() AS cohort_size
    FROM (
        SELECT user_id, min(toDate(time)) AS first_day, any(source) AS source
        FROM simulator_20260820.feed_actions
        GROUP BY user_id
        HAVING first_day IN (toDate('2026-08-06'), toDate('2026-08-13'))
    )
    GROUP BY cohort
) c ON r.cohort = c.cohort
ORDER BY cohort, day_number
