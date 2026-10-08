-- Synthetic single-currency USD data; values are integer cents.
INSERT INTO customers VALUES ('C01','West'),('C02','North'),('C03','West'),('C04','South');
INSERT INTO orders VALUES
('O01','C01','2026-08-01','completed'),
('O02','C02','2026-08-03','completed'),
('O03','C01','2026-09-02','completed'),
('O04','C03','2026-09-05','cancelled'),
('O05','C03','2026-09-06','completed'),
('O06','C04','2026-09-08','completed');
INSERT INTO order_items VALUES
('O01',1,'Electronics',1,10000,0),
('O01',2,'Accessories',2,1500,500),
('O02',1,'Home',1,8000,1000),
('O03',1,'Accessories',1,3000,0),
('O04',1,'Electronics',1,20000,0),
('O05',1,'Home',2,5000,0),
('O06',1,'Electronics',1,15000,1500);
