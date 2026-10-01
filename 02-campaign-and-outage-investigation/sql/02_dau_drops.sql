-- Дни с самым сильным падением DAU относительно предыдущего дня
SELECT t.day AS day,
       t.dau AS dau,
       p.dau AS prev_day_dau,
       round((t.dau / p.dau - 1) * 100, 1) AS change_pct
FROM (
    SELECT toDate(time) AS day, uniqExact(user_id) AS dau
    FROM simulator_20260820.feed_actions
    GROUP BY day
) t
JOIN (
    SELECT day + 1 AS next_day, dau
    FROM (
        SELECT toDate(time) AS day, uniqExact(user_id) AS dau
        FROM simulator_20260820.feed_actions
        GROUP BY day
    )
) p ON t.day = p.next_day
WHERE t.day < today()
ORDER BY change_pct
LIMIT 5
