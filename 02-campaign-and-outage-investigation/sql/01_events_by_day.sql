-- DAU ленты и новые пользователи по источнику трафика по дням
SELECT a.day AS day,
       a.dau AS dau,
       n.new_ads AS new_ads,
       n.new_organic AS new_organic
FROM (
    SELECT toDate(time) AS day, uniqExact(user_id) AS dau
    FROM simulator_20260820.feed_actions
    GROUP BY day
) a
LEFT JOIN (
    SELECT first_day AS day,
           countIf(source = 'ads')     AS new_ads,
           countIf(source = 'organic') AS new_organic
    FROM (
        SELECT user_id, min(toDate(time)) AS first_day, any(source) AS source
        FROM simulator_20260820.feed_actions
        GROUP BY user_id
    )
    GROUP BY day
) n USING day
WHERE day < today()
ORDER BY day
