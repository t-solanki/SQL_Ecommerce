CREATE TABLE goldusers_signup(userid integer,gold_signup_date date);
INSERT INTO goldusers_signup(userid,gold_signup_date)
VALUES (1,'2017-09-22'),
(3,'2017-04-21');

CREATE TABLE users(userid integer,signup_date date); 
INSERT INTO users(userid,signup_date) 
VALUES (1,'2014-09-02'),
(2,'2015-01-15'),
(3,'2014-04-11');

CREATE TABLE sales(userid integer,created_date date,product_id integer);
INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'2017-04-19',2),
(3,'2019-12-18',1),
(2,'2020-07-20',3),
(1,'2019-10-23',2),
(1,'2018-03-19',3),
(3,'2016-12-20',2),
(1,'2016-11-09',1),
(1,'2016-05-20',3),
(2,'2017-09-24',1),
(1,'2017-03-11',2),
(1,'2016-03-11',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);

CREATE TABLE product(product_id integer,product_name text,price integer);
INSERT INTO product(product_id,product_name,price) 
VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);

SELECT * FROM goldusers_signup;
SELECT * FROM sales;
SELECT * FROM users;
SELECT * FROM product;

  -- 1. What is the total amount each customer spent on Zomato? --
  
SELECT sales.userid, SUM(product.price) AS Total_Spent
FROM sales
JOIN product
ON sales.product_id = product.product_id
GROUP BY sales.userid;

-- 2.How many days each customer visited zomato? --

SELECT sales.userid, COUNT(DISTINCT created_date) AS Days_Spent
FROM sales
GROUP BY sales.userid;
  
-- 3. What was the first product purchased by each customer? --

SELECT * FROM
(SELECT *,
RANK() OVER(PARTITION BY userid ORDER BY created_date) RNK FROM sales) AS RNK_TABLE
WHERE RNK = 1;

-- 4. What is the most purchased item on the menu and how many time it purchased? --

SELECT userid,COUNT(product_id) AS total_count FROM sales WHERE product_id = 
(SELECT product_id
FROM sales
GROUP BY product_id
ORDER BY COUNT(product_id) DESC 
LIMIT 1)
GROUP BY userid
ORDER BY userid;

-- 5. Which item was most popular for each customer? --

SELECT * FROM
(SELECT *, RANK() OVER(PARTITION BY userid ORDER BY cnt DESC) AS rnk FROM
(SELECT userid, product_id, COUNT(product_id) AS cnt
FROM sales
GROUP BY userid, product_id) AS cnt_tbl) AS rnk_tbl
WHERE rnk = 1;




