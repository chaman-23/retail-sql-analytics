-- Aggregate each order before calculating AOV, avoiding item-join inflation.
WITH order_totals AS (
  SELECT o.order_id, substr(o.order_date,1,7) AS month,
         SUM(i.quantity*i.unit_price_cents-i.discount_cents) AS net_cents
  FROM orders o JOIN order_items i USING (order_id)
  WHERE o.status='completed'
  GROUP BY o.order_id, month
), monthly AS (
  SELECT month, COUNT(*) AS orders, SUM(net_cents) AS net_cents,
         ROUND(AVG(net_cents)/100.0,2) AS average_order_value
  FROM order_totals GROUP BY month
)
SELECT month, orders, ROUND(net_cents/100.0,2) AS net_sales_usd, average_order_value,
       ROUND((net_cents-LAG(net_cents) OVER (ORDER BY month))*100.0 /
             NULLIF(LAG(net_cents) OVER (ORDER BY month),0),2) AS change_vs_previous_observed_month_pct
FROM monthly ORDER BY month;
