-- =====================================================
-- Multi-Vendor SaaS E-Commerce Database
-- SQL Assignment
-- =====================================================


-- =====================================================
-- PART B: DDL
-- =====================================================

-- 1. SubscriptionPlan Table
CREATE TABLE SubscriptionPlan (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    duration INT NOT NULL,
    features TEXT
);


-- 2. Vendor Table
CREATE TABLE Vendor (
    vendor_id INT AUTO_INCREMENT PRIMARY KEY,
    business_name VARCHAR(150) NOT NULL,
    contact_person VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(30),
    business_address VARCHAR(255),
    plan_id INT NOT NULL,

    FOREIGN KEY (plan_id)
        REFERENCES SubscriptionPlan(plan_id)
);


-- 3. Product Table
CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id INT NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(12,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',

    FOREIGN KEY (vendor_id)
        REFERENCES Vendor(vendor_id)
);


-- 4. Category Table
CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);


-- 5. ProductCategory Table
-- This table handles Product <-> Category many-to-many relationship
CREATE TABLE ProductCategory (
    product_id INT NOT NULL,
    category_id INT NOT NULL,

    PRIMARY KEY (product_id, category_id),

    FOREIGN KEY (product_id)
        REFERENCES Product(product_id)
        ON DELETE CASCADE,

    FOREIGN KEY (category_id)
        REFERENCES Category(category_id)
        ON DELETE CASCADE
);


-- 6. Customer Table
CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(30),
    address VARCHAR(255)
);


-- 7. Orders Table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(50) NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
);


-- 8. OrderItem Table
CREATE TABLE OrderItem (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
        ON DELETE CASCADE,

    FOREIGN KEY (product_id)
        REFERENCES Product(product_id)
);


-- 9. Payment Table
CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    method ENUM(
        'Card',
        'Bkash',
        'PayPal',
        'Cash on Delivery'
    ) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
        ON DELETE CASCADE
);


-- =====================================================
-- PART C: DML
-- =====================================================

-- 1. Insert Basic Subscription Plan
INSERT INTO SubscriptionPlan
(
    plan_name,
    price,
    duration,
    features
)
VALUES
(
    'Basic',
    500.00,
    30,
    'Basic vendor features'
);


-- 2. Insert SmartTech Ltd. Vendor
INSERT INTO Vendor
(
    business_name,
    contact_person,
    email,
    phone,
    business_address,
    plan_id
)
VALUES
(
    'SmartTech Ltd.',
    'Rahim Khan',
    'rahim@smarttech.com',
    '017XXXXXXXX',
    'Dhaka, Bangladesh',

    (
        SELECT plan_id
        FROM SubscriptionPlan
        WHERE plan_name = 'Basic'
    )
);


-- 3. Insert Electronics Category
INSERT INTO Category
(
    category_name,
    description
)
VALUES
(
    'Electronics',
    'Electronic devices and accessories'
);


-- 4. Insert Laptop Product
INSERT INTO Product
(
    vendor_id,
    product_name,
    description,
    price,
    stock_quantity,
    status
)
VALUES
(
    (
        SELECT vendor_id
        FROM Vendor
        WHERE business_name = 'SmartTech Ltd.'
    ),

    'Laptop',
    'High performance laptop',
    75000.00,
    10,
    'active'
);


-- 5. Connect Laptop with Electronics Category
INSERT INTO ProductCategory
(
    product_id,
    category_id
)
VALUES
(
    (
        SELECT product_id
        FROM Product
        WHERE product_name = 'Laptop'
    ),

    (
        SELECT category_id
        FROM Category
        WHERE category_name = 'Electronics'
    )
);


-- 6. Update Laptop Stock
UPDATE Product
SET stock_quantity = 15
WHERE product_name = 'Laptop';


-- 7. Delete Customer
DELETE FROM Customer
WHERE email = 'oldcustomer@gmail.com';


-- =====================================================
-- PART D: DQL
-- =====================================================

-- 1. Display all vendors with subscription plan name and price
SELECT
    v.vendor_id,
    v.business_name,
    v.contact_person,
    v.email,
    sp.plan_name,
    sp.price
FROM Vendor v
JOIN SubscriptionPlan sp
    ON v.plan_id = sp.plan_id;


-- 2. Display products under Electronics category
SELECT
    p.product_name,
    p.price,
    p.stock_quantity
FROM Product p
JOIN ProductCategory pc
    ON p.product_id = pc.product_id
JOIN Category c
    ON pc.category_id = c.category_id
WHERE c.category_name = 'Electronics';


-- 3. Display orders of customer Karim Uddin
SELECT
    o.order_id,
    o.order_date,
    o.total_amount,
    o.status
FROM Orders o
JOIN Customer c
    ON o.customer_id = c.customer_id
WHERE c.name = 'Karim Uddin';


-- 4. Display payment details for Order ID 1
SELECT
    method,
    amount,
    status
FROM Payment
WHERE order_id = 1;


-- 5. Display Top 5 Best-Selling Products
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM OrderItem oi
JOIN Product p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    total_quantity_sold DESC
LIMIT 5;