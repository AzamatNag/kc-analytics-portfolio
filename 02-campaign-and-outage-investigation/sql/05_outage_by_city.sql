-- Изменение аудитории ленты по городам: день сбоя (22.08) vs неделей раньше (15.08)
SELECT country, city,
       uniqExactIf(user_id, toDate(time) = toDate('2026-08-15')) AS users_15_08,
       uniqExactIf(user_id, toDate(time) = toDate('2026-08-22')) AS users_22_08,
       round((users_22_08 / users_15_08 - 1) * 100, 1)          AS change_pct
FROM simulator_20260820.feed_actions
WHERE toDate(time) IN (toDate('2026-08-15'), toDate('2026-08-22'))
GROUP BY country, city
HAVING users_15_08 > 50
ORDER BY change_pct
LIMIT 20
