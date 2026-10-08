WITH customer_sales AS (
  SELECT o.customer_id, COUNT(DISTINCT o.order_id) AS completed_orders,
         SUM(i.quantity*i.unit_price_cents-i.discount_cents) AS net_cents
  FROM orders o JOIN order_items i USING(order_id)
  WHERE o.status='completed'
  GROUP BY o.customer_id
)
SELECT c.customer_id, c.region, COALESCE(s.completed_orders,0) AS completed_orders,
       ROUND(COALESCE(s.net_cents,0)/100.0,2) AS net_sales_usd,
       CASE WHEN s.completed_orders >= 2 THEN 'Repeat'
            WHEN s.completed_orders = 1 THEN 'One-time' ELSE 'No completed orders' END AS segment
FROM customers c LEFT JOIN customer_sales s USING(customer_id)
ORDER BY net_sales_usd DESC, c.customer_id;
