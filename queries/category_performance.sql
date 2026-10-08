SELECT i.category, SUM(i.quantity) AS units,
       ROUND(SUM(i.quantity*i.unit_price_cents-i.discount_cents)/100.0,2) AS net_sales_usd
FROM order_items i JOIN orders o USING(order_id)
WHERE o.status='completed'
GROUP BY i.category ORDER BY net_sales_usd DESC, i.category;
