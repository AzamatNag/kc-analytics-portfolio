-- Пользователи ленты, ни разу не отправившие сообщение за весь период
SELECT uniqExact(user_id) AS feed_only_users
FROM simulator_20260820.feed_actions
WHERE user_id NOT IN (SELECT user_id FROM simulator_20260820.message_actions)
