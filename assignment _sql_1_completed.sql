create schema assignment;
USE ASSIGNMENT ;

CREATE TABLE Customers (
CustomerID INT,
CustomerName VARCHAR(50),
City VARCHAR(30),
JoinDate DATE
);

INSERT INTO Customers VALUES
(101,'Rahul Sharma','Bangalore','2023-01-15'),
(102,'Priya Mehta','Mumbai','2024-03-20'),
(103,'Arjun Nair','Chennai','2025-01-12'),
(104,'Sneha Gupta','Delhi','2022-07-10'),
(105,'Kavya Reddy','Hyderabad','2024-08-15'),
(106,'Amit Verma','Pune','2023-11-05'),
(107,'Rohan
 Singh','Kolkata','2024-05-18'),
(108,'Simran Kaur','Delhi','2025-02-01'),
(109,'Anjali Jain','Mumbai','2023-09-22'),
(110,'Vikram Patel','Ahmedabad','2022-12-30');

CREATE TABLE Orders (
OrderID INT,
CustomerID INT,
OrderDate DATE,
OrderAmount DECIMAL(10,2),
Status VARCHAR(20)
);
INSERT INTO Orders VALUES
(5001,101,'2025-01-05',12000,'Delivered'),
(5002,102,'2025-01-15',8500,'Pending'),
(5003,101,'2025-02-10',22000,'Delivered'),
(5004,104,'2025-02-15',4500,'Cancelled'),
(5005,103,'2025-03-01',17500,'Delivered'),
(5006,105,'2025-03-10',9800,'Pending'),
(5007,106,'2025-03-18',25000,'Delivered'),
(5008,107,'2025-04-02',14500,'Delivered'),
(5009,101,'2025-04-10',30000,'Delivered'),
(5010,109,'2025-04-15',6500,'Pending'),
(5011,110,'2025-05-01',42000,'Delivered'),
(5012,104,'2025-05-08',18000,'Delivered'),
(5013,106,'2025-05-15',7000,'Cancelled'),
(5014,102,'2025-05-20',27000,'Delivered'),
(5015,107,'2025-06-01',15500,'Pending');
CREATE TABLE Employees (
EmployeeID INT,
EmployeeName VARCHAR(50),
ManagerID INT,
Department VARCHAR(30),
JoiningDate DATE,
Salary DECIMAL(10,2)
);
INSERT INTO Employees VALUES
(1,'Rajesh Kumar',NULL,'Management','2018-01-10',150000),
(2,'Neha Sharma',1,'Sales','2020-03-15',90000),
(3,'Amit Gupta',1,'IT','2019-06-20',110000),
(4,'Priyanka Singh',2,'Sales','2022-01-12',65000),
(5,'Vikas Patel',2,'Sales','2021-09-18',70000),
(6,'Rohit Jain',3,'IT','2023-02-05',60000),
(7,'Anjali Verma',3,'IT','2022-11-10',62000),
(8,'Karan Mehta',1,'HR','2021-05-25',80000),
(9,'Sneha Kapoor',8,'HR','2024-01-05',50000),
(10,'Arjun Malhotra',3,'IT','2024-04-15',55000);

select * from customers;
select * from employees;
select * from ORDERS;
 

/* Question 1
A retail company wants to reward its most valuable customers. Display the
top 5 highest-value orders along with customer names. */

SELECT C.CUSTOMERNAME, O.ORDERAMOUNT  FROM CUSTOMERS C INNER JOIN ORDERS O 
ON C.CUSTOMERID = O.CUSTOMERID  ORDER BY ORDERAMOUNT DESC LIMIT  5;

/* Question 2
The marketing team wants to send promotional emails to customers whose
names start with 'A', 'R', or 'S'.                                                                            GADBAD
Write a query without using multiple OR conditions.*/

SELECT CUSTOMERNAME FROM CUSTOMERS WHERE CUSTOMERNAME   IN ('A%', 'R%','S%') ;

/*Question 3
Management wants to identify customers who have placed orders worth
more than ₹10,000 but whose order status is still Pending.
Display:
● Customer Name
● Order ID
● Order Amount
● Status                                  */

SELECT C.CUSTOMERNAME, O.ORDERID, O.ORDERAMOUNT, O.STATUS FROM CUSTOMERS C LEFT JOIN ORDERS O 
ON C.CUSTOMERID=O.CUSTOMERID WHERE ORDERAMOUNT> 10000 AND STATUS='PENDING';

/* Question 4
The customer success team wants to identify customers who joined more
than 365 days ago.                                                                                            
Display the number of days each customer has been associated with the
company     */
  SELECT DATEDIFF(current_date(),JOINDATE) AS ASSOCIATE_DAYS FROM CUSTOMERS WHERE DATEDIFF(current_date(),JOINDATE)>365  ;
  
  /*  Question 5
The finance department wants to estimate future revenue.
Create a report showing:
● Order ID
● Current Amount
● 18% GST
● Total Amount After GST            
● Expected Collection Date (15 days after order date)     */

SELECT ORDERID, ORDERAMOUNT AS CUREENT_AMOUNT, 
ORDERAMOUNT*0.18 AS GST, 
ORDERAMOUNT*0.18 + ORDERAMOUNT AS AMOUNT_AFTER_GST,
DATE_ADD( ORDERDATE, INTERVAL 15 DAY ) AS EXPECTED_COLLECTION_DATE
 FROM ORDERS;

/*   Question 6
The operations team wants to review the customers ranked between 11th and
20th highest orders.
Use LIMIT and OFFSET */   

SELECT ORDERAMOUNT FROM ORDERS ORDER BY  ORDERAMOUNT DESC LIMIT 10 OFFSET 10;


/*   Question 7
An e-commerce company wants to identify customers who have never
placed any order despite registering on the platform.
Display:
● Customer ID
● Customer Name
● Join Date
● Number of Days Since Registration               */

 SELECT  C.CUSTOMERID,C.CUSTOMERNAME,C.JOINDATE,DATEDIFF(CURDATE(),C.JOINDATE) AS DAYS_SINCE_REGISTRATION FROM CUSTOMERS  C LEFT JOIN ORDERS O ON C.CUSTOMERID=O.CUSTOMERID  WHERE O.ORDERID IS NULL;

/* Question 8
The HR department wants to analyze organizational hierarchy.
Using a JOIN, display:
● Employee Name
● Manager Name
● Department          */

SELECT E.EMPLOYEENAME, M.EMPLOYEENAME AS MANAGERNAME , E.DEPARTMENT FROM EMPLOYEES E LEFT JOIN EMPLOYEES M ON  E.MANAGERID=M.EMPLOYEEID;

 /*   Question 9
The sales director wants a report of customers who placed orders within 30
days of joining the platform.
Display:
● Customer Name
● Join Date
● Order Date
● Days Taken To Place First Order        */

SELECT C.CUSTOMERNAME ,C.JOINDATE,O.ORDERDATE  ,
DATEDIFF(O.ORDERDATE,C.JOINDATE) AS FIRSTORDERS_DAYS                                        -- GADBAD 
FROM CUSTOMERS C  LEFT JOIN ORDERS O 
ON C.CUSTOMERID=O.CUSTOMERID 
 WHERE DATEDIFF(O.ORDERDATE,C.JOINDATE)<= 30;
 
 
/*  Question 10
Business Requirement
Generate a report showing:
● Customer Name
● Total Purchase Amount
● Spending Category
● Loyalty Status
Rules
Spending Category
● Premium → Total Purchases > ₹50,000
● Gold → ₹20,000 to ₹50,000
● Silver → Less than ₹20,000
Loyalty Status
● Joined before 2024 → Loyal Customer
● Otherwise → New Customer      */

SELECT  C.CUSTOMERNAME ,
SUM(O.ORDERAMOUNT)  AS TOTAL_PURCHASE_AMOUNT  ,
CASE 
     WHEN SUM(O.ORDERAMOUNT)  > 50000 THEN  "PREMIUM"
     WHEN SUM(O.ORDERAMOUNT) BETWEEN 20000 AND 50000 THEN "Gold"
     WHEN SUM(O.ORDERAMOUNT)  < 20000 THEN  "Silver"
      end as spending_category ,
  case 
    when c.joindate <'2024-01-01' then "loyal_customer" 
    else "new_customer"
    end as loyalty_status 
    
    from  customers c left join orders o 
    on c.customerid=o.customerid
    
 GROUP BY
    C.CUSTOMERID,
    C.CUSTOMERNAME,
    C.JOINDATE;    
     
/* Question 11 : An online marketplace wants to find customers whose order
amount is higher than the average order amount of all orders.
Display:
● Customer Name
● Order ID
● Order Amount          */
select c.customername,o.orderid,o.orderamount from customers c left join orders o on c.customerid=o.customerid where  o.orderamount>(select avg(o.orderamount)

from orders );


/*Question 12
The management team wants the 2nd to 6th highest orders placed by
customers.
Display:
● Customer Name
● Order ID
● Order Amount  */ 

select c.customername ,o.orderid,o.orderamount 
from customers c right join orders o 
  on c.customerid=o.customerid 
  order by  orderamount desc limit 6 offset 2;

 

