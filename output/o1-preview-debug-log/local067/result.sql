WITH customer_profits AS (
  SELECT
    sales.cust_id,
    SUM(sales.amount_sold - (sales.quantity_sold * costs.unit_cost)) AS total_profit
  FROM sales
  JOIN customers ON sales.cust_id = customers.cust_id
  JOIN countries ON customers.country_id = countries.country_id
  JOIN times ON sales.time_id = times.time_id
  JOIN costs ON sales.prod_id = costs.prod_id
           AND sales.time_id = costs.time_id
           AND sales.channel_id = costs.channel_id
           AND sales.promo_id = costs.promo_id
  WHERE
    countries.country_name = 'Italy'
    AND times.calendar_year = 2021
    AND times.calendar_month_number = 12
  GROUP BY sales.cust_id
),
ranked_customers AS (
  SELECT
    cust_id,
    total_profit,
    ROW_NUMBER() OVER (ORDER BY total_profit DESC) AS rn,
    COUNT(*) OVER () AS total_customers
  FROM customer_profits
),
customers_with_tiers AS (
  SELECT
    cust_id,
    total_profit,
    rn,
    total_customers,
    CAST( ((rn - 1) * 10.0 / total_customers) AS INTEGER ) + 1 AS tier
  FROM ranked_customers
)
SELECT
  tier,
  ROUND(MAX(total_profit), 4) AS Highest_Profit,
  ROUND(MIN(total_profit), 4) AS Lowest_Profit
FROM customers_with_tiers
GROUP BY tier
ORDER BY tier;