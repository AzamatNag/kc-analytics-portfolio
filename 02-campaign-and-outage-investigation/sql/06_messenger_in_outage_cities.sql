-- Работал ли мессенджер в городах, где упала лента
SELECT city,
       uniqExactIf(user_id, toDate(time) = toDate('2026-08-15')) AS msg_users_15_08,
       uniqExactIf(user_id, toDate(time) = toDate('2026-08-22')) AS msg_users_22_08
FROM simulator_20260820.message_actions
WHERE toDate(time) IN (toDate('2026-08-15'), toDate('2026-08-22'))
  AND city IN ('Moscow', 'Saint Petersburg', 'Yekaterinburg', 'Novosibirsk')
GROUP BY city
ORDER BY msg_users_15_08 DESC
