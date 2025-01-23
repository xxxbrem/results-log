SELECT a.first_name || ' ' || a.last_name AS Full_name
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
JOIN film AS f ON fa.film_id = f.film_id
WHERE f.release_year BETWEEN '2000' AND '2010'
  AND f.language_id = (SELECT language_id FROM language WHERE name = 'English')
  AND f.rating IN ('G', 'PG')
  AND f.length <= 120
GROUP BY a.actor_id
ORDER BY COUNT(*) DESC
LIMIT 1;