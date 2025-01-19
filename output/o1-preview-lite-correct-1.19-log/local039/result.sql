SELECT category.name AS Category, ROUND(SUM(
    (julianday(rental.return_date) - julianday(rental.rental_date)) * 24
), 4) AS TotalRentalHours
FROM rental
JOIN customer ON rental.customer_id = customer.customer_id
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE (city.city LIKE 'A%' OR city.city LIKE '%-%')
  AND rental.return_date IS NOT NULL
GROUP BY category.category_id, category.name
ORDER BY TotalRentalHours DESC
LIMIT 1;