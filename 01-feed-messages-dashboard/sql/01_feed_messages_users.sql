-- Сегмент пользователя за каждый день: лента + сообщения / только лента / только сообщения
SELECT
    day,
    user_id,
    multiIf(max(in_feed) = 1 AND max(in_msg) = 1, 'лента + сообщения',
            max(in_feed) = 1, 'только лента',
            'только сообщения') AS segment,
    any(os)      AS os,
    any(source)  AS source,
    any(country) AS country,
    any(gender)  AS gender,
    any(age)     AS age
FROM (
    SELECT toDate(time) AS day, user_id, 1 AS in_feed, 0 AS in_msg,
           os, source, country, gender, age
    FROM simulator_20260820.feed_actions
    UNION ALL
    SELECT toDate(time) AS day, user_id, 0 AS in_feed, 1 AS in_msg,
           os, source, country, gender, age
    FROM simulator_20260820.message_actions
)
WHERE day < today()
GROUP BY day, user_id
