import sqlite3
import unittest
from run_analysis import analyze, build_database

class RetailTests(unittest.TestCase):
    def setUp(self):
        self.db = build_database()
    def tearDown(self):
        self.db.close()
    def rows(self, name):
        return analyze(self.db)[name][1]

    def test_monthly_revenue_and_order_grain(self):
        rows = self.rows('monthly_revenue')
        self.assertEqual(rows[0], ('2026-08',2,195.0,97.5,None))
        self.assertEqual(rows[1], ('2026-09',3,265.0,88.33,35.9))

    def test_cancelled_order_excluded(self):
        self.assertEqual(sum(r[2] for r in self.rows('category_performance')), 460)

    def test_multiple_items_do_not_create_repeat_customer(self):
        rows = {r[0]:r for r in self.rows('customer_segments')}
        self.assertEqual(rows['C01'][2:], (2,155.0,'Repeat'))
        self.assertEqual(rows['C02'][2], 1)

    def test_no_order_customer_retained(self):
        self.db.execute("INSERT INTO customers VALUES ('C05','East')")
        rows = {r[0]:r for r in self.rows('customer_segments')}
        self.assertEqual(rows['C05'][2:], (0,0.0,'No completed orders'))

    def test_constraints_reject_invalid_data(self):
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.execute("INSERT INTO order_items VALUES ('O01',8,'X',1,100,200)")
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.execute("INSERT INTO orders VALUES ('O99','missing','2026-09-01','completed')")

if __name__ == '__main__':
    unittest.main()
