-- Активная аудитория по неделям: new / retained / returned / gone
-- gone: были активны на прошлой неделе, на этой нет (со знаком минус)
SELECT this_week, status, -toInt64(uniqExact(user_id)) AS num_users
FROM (
    SELECT user_id,
           groupUniqArray(toMonday(toDate(time))) AS weeks_visited,
           arrayJoin(weeks_visited) AS previous_week,
           addWeeks(previous_week, 1) AS this_week,
           'gone' AS status
    FROM simulator_20260820.feed_actions
    GROUP BY user_id
)
WHERE NOT has(weeks_visited, this_week)
  AND this_week < toMonday(today())
GROUP BY this_week, status

UNION ALL

-- new: первая активность на этой неделе
-- retained: активны и на этой, и на прошлой неделе
-- returned: были активны раньше, пропустили прошлую неделю и вернулись
SELECT this_week, status, toInt64(uniqExact(user_id)) AS num_users
FROM (
    SELECT user_id,
           groupUniqArray(toMonday(toDate(time))) AS weeks_visited,
           arrayJoin(weeks_visited) AS this_week,
           addWeeks(this_week, -1) AS previous_week,
           multiIf(this_week = arrayMin(weeks_visited), 'new',
                   has(weeks_visited, previous_week), 'retained',
                   'returned') AS status
    FROM simulator_20260820.feed_actions
    GROUP BY user_id
)
WHERE this_week < toMonday(today())
GROUP BY this_week, status
