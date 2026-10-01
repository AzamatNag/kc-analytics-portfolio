-- Состав когорты кампании vs обычной рекламы: страна
SELECT country,
       countIf(first_day = toDate('2026-08-13')) AS campaign_13_08,
       countIf(first_day = toDate('2026-08-06')) AS usual_06_08
FROM (
    SELECT user_id, min(toDate(time)) AS first_day,
           any(source) AS source, any(country) AS country
    FROM simulator_20260820.feed_actions
    GROUP BY user_id
)
WHERE source = 'ads'
  AND first_day IN (toDate('2026-08-06'), toDate('2026-08-13'))
GROUP BY country WITH TOTALS
ORDER BY campaign_13_08 DESC;

-- Состав когорты кампании vs обычной рекламы: ОС и возрастная группа
SELECT os,
       multiIf(age < 18, 'до 18', age < 25, '18-24', age < 35, '25-34',
               age < 45, '35-44', '45+') AS age_group,
       countIf(first_day = toDate('2026-08-13')) AS campaign_13_08,
       countIf(first_day = toDate('2026-08-06')) AS usual_06_08
FROM (
    SELECT user_id, min(toDate(time)) AS first_day,
           any(source) AS source, any(os) AS os, any(age) AS age
    FROM simulator_20260820.feed_actions
    GROUP BY user_id
)
WHERE source = 'ads'
  AND first_day IN (toDate('2026-08-06'), toDate('2026-08-13'))
GROUP BY os, age_group WITH TOTALS
ORDER BY os, age_group;

-- Активность в первый день: кампания vs обычная реклама
SELECT if(u.first_day = toDate('2026-08-13'), 'кампания 13.08', 'обычные ads 06.08') AS cohort,
       uniqExact(f.user_id) AS users,
       round(countIf(f.action = 'view') / uniqExact(f.user_id), 1) AS views_per_user,
       round(countIf(f.action = 'like') / uniqExact(f.user_id), 1) AS likes_per_user,
       round(countIf(f.action = 'like') / countIf(f.action = 'view'), 3) AS ctr
FROM simulator_20260820.feed_actions f
JOIN (
    SELECT user_id, min(toDate(time)) AS first_day, any(source) AS source
    FROM simulator_20260820.feed_actions
    GROUP BY user_id
    HAVING source = 'ads' AND first_day IN (toDate('2026-08-06'), toDate('2026-08-13'))
) u ON f.user_id = u.user_id
WHERE toDate(f.time) = u.first_day
GROUP BY cohort;
