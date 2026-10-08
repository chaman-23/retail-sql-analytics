PRAGMA foreign_keys = ON;
CREATE TABLE customers (
  customer_id TEXT PRIMARY KEY,
  region TEXT NOT NULL
);
CREATE TABLE orders (
  order_id TEXT PRIMARY KEY,
  customer_id TEXT NOT NULL REFERENCES customers(customer_id),
  order_date TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('completed', 'cancelled'))
);
CREATE TABLE order_items (
  order_id TEXT NOT NULL REFERENCES orders(order_id),
  line_id INTEGER NOT NULL,
  category TEXT NOT NULL,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  unit_price_cents INTEGER NOT NULL CHECK (unit_price_cents >= 0),
  discount_cents INTEGER NOT NULL DEFAULT 0 CHECK (discount_cents >= 0 AND discount_cents <= quantity * unit_price_cents),
  PRIMARY KEY (order_id, line_id)
);
