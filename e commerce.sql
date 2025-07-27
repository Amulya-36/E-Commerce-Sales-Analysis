CREATE DATABASE e_commerce_sales;
USE e_commerce_sales;
-- Table for Brands
CREATE TABLE Brands (
    brand_id VARCHAR(20) PRIMARY KEY,
    brand_name VARCHAR(100)
);
-- Table for Categories
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE
);
-- Table for Subcategory Level 1
CREATE TABLE Subcategories1 (
    subcat1_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE
);
-- Table for Subcategory Level 2
CREATE TABLE Subcategories2 (
    subcat2_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE
);
-- Table for Products
CREATE TABLE Products (
    product_id VARCHAR(20) PRIMARY KEY,
    brand_id VARCHAR(20),
    category_id INT,
    subcat1_id INT,
    subcat2_id INT,
    FOREIGN KEY (brand_id) REFERENCES Brands(brand_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (subcat1_id) REFERENCES Subcategories1(subcat1_id),
    FOREIGN KEY (subcat2_id) REFERENCES Subcategories2(subcat2_id)
);
-- Table for Sales
CREATE TABLE Sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(20),
    item_rating DECIMAL(3,1),
    sale_date DATE,
    selling_price DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
CREATE TABLE RawSales (
    Product VARCHAR(20),
    Product_Brand VARCHAR(20),
    Item_Category VARCHAR(100),
    Subcategory_1 VARCHAR(100),
    Subcategory_2 VARCHAR(100),
    Item_Rating DECIMAL(3,1),
    Sale_Date VARCHAR(20),  -- renamed from Date
    Selling_Price DECIMAL(10,2)
);
SELECT VERSION();
SELECT * FROM RawSales LIMIT 10;
INSERT INTO Brands (brand_id, brand_name)
SELECT DISTINCT Product_Brand, Product_Brand
FROM RawSales;
INSERT INTO Categories (name)
SELECT DISTINCT Item_Category
FROM RawSales;
INSERT INTO Subcategories1 (name)
SELECT DISTINCT Subcategory_1
FROM RawSales;
INSERT INTO Subcategories2 (name)
SELECT DISTINCT Subcategory_2
FROM RawSales;
INSERT INTO Products (product_id, brand_id, category_id, subcat1_id, subcat2_id)
SELECT DISTINCT
    r.Product,
    r.Product_Brand,
    c.category_id,
    s1.subcat1_id,
    s2.subcat2_id
FROM RawSales r
JOIN Categories c ON r.Item_Category = c.name
JOIN Subcategories1 s1 ON r.Subcategory_1 = s1.name
JOIN Subcategories2 s2 ON r.Subcategory_2 = s2.name;
INSERT INTO Sales (product_id, item_rating, sale_date, selling_price)
SELECT 
    r.Product,
    r.Item_Rating,
    STR_TO_DATE(r.Sale_Date, '%d/%m/%Y'),  
    r.Selling_Price
FROM RawSales r;
SELECT * FROM Sales LIMIT 10;
SELECT SUM(selling_price) AS total_revenue FROM Sales;
SELECT 
    c.name AS category,
    SUM(s.selling_price) AS revenue
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
GROUP BY c.name
ORDER BY revenue DESC;
SELECT 
    p.product_id,
    SUM(s.selling_price) AS total_revenue
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_revenue DESC
LIMIT 5;
SELECT 
    DATE_FORMAT(s.sale_date, '%Y-%m') AS month,
    SUM(s.selling_price) AS monthly_revenue
FROM Sales s
GROUP BY month
ORDER BY month;









