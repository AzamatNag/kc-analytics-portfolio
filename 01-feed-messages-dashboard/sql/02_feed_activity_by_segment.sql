-- Активность в ленте (просмотры, лайки, CTR) у пользователей с сообщениями и без
SELECT f.day AS day,
       if(m.has_msg = 1, 'лента + сообщения', 'только лента') AS segment,
       countIf(f.action = 'view') / uniqExact(f.user_id) AS views_per_user,
       countIf(f.action = 'like') / uniqExact(f.user_id) AS likes_per_user,
       countIf(f.action = 'like') / countIf(f.action = 'view') AS ctr
FROM (SELECT toDate(time) AS day, user_id, action
      FROM simulator_20260820.feed_actions) f
LEFT JOIN (SELECT DISTINCT toDate(time) AS day, user_id, 1 AS has_msg
           FROM simulator_20260820.message_actions) m
       ON f.day = m.day AND f.user_id = m.user_id
WHERE f.day < today()
GROUP BY day, segment
