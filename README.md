# Retail SQL Analytics

**A reproducible SQL case study: revenue, product categories and repeat customers.**

This project focuses on a common analytics mistake: joining orders to line items and accidentally inflating order counts. It models the two grains explicitly, excludes cancelled orders, and uses integer cents for monetary inputs.

## Run it

Python 3.10+ with its bundled SQLite; no external dependencies. From the repository root:

```bash
python run_analysis.py
python -m unittest discover -v
```

Three CSV reports are written under `reports/`. The database runs in memory; every run starts with the same synthetic dataset. Example results are also committed under `examples/`.

## Questions answered

| Question | SQL |
| --- | --- |
| How do net sales and average order value change? | `queries/monthly_revenue.sql` |
| Which categories generate sales? | `queries/category_performance.sql` |
| Which customers have returned? | `queries/customer_segments.sql` |

## Reproduce these findings

- Five completed orders generate **USD 460.00** after line discounts.
- August: **USD 195.00**, 2 orders, **USD 97.50 AOV**.
- September: **USD 265.00**, 3 orders, **USD 88.33 AOV**.
- Sales rise **35.90%** versus August; AOV falls. The tiny sample illustrates calculations, not a statistically supported business trend.
- C01 is a repeat customer with two completed orders; multiple items in one order do not count as repeat purchases.

## Data model and definitions

`customers (1) → (many) orders (1) → (many) order_items`

Net sales = quantity × unit price − line discount. AOV = net sales / completed orders that contain items. Cancelled orders are excluded. Discounts are total cents per line, not per unit. Currency is USD throughout. Tax, shipping, returns and refunds are not modeled; net sales here are not profit or accounting revenue. Customers without completed orders remain in the segmentation report.

The month comparison uses the previous **observed** month; a missing month is not inserted as zero. Dates in the fixture are ISO strings. The schema is educational and does not fully validate calendar dates.

## Explore

Edit `sample.sql`, rerun the analysis, or open the SQL files in a SQLite editor. Import the CSV outputs into Excel or Power BI for a visual presentation. No Power BI file or deployed dashboard is included.
