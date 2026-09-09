/*1. Creating a database*/
create database InventoryDB;
/*Query to use the database*/
use InventoryDB;


/*2. Creating Items table*/
create table Items(
ItemID int primary Key, 
ItemName varchar(50),
Category varchar(50),
Price float,
StockQuantity int
);

/*3. Inserting into Items table*/
insert into Items values
(001, 'Desk', 'Furniture', 300.00, 20),
(002, 'Chair', 'Furniture', 150.00, 50), 
(003, 'Notebook', 'Stationery', 10.00, 100),
(004, 'Pen', 'Stationery', 2.00, 200),
(005, 'Monitor', 'Electronics', 250.00, 30)


/*4. Creating Customer table*/
create table Customers(
CustomerID int primary key,
FirstName varchar(50),
LastName varchar(50),
Email varchar(100),
Phone varchar(15)
);

/*5. Inserting into Customer table*/
insert into Customers values
(101, 'Mandla', 'Xaba', 'mandla.xaba@gmail.com ', '081-456-7890'),
(102, 'Mlondi', 'Nzama', 'mlondi.nzama@gmail.com', '073-567-8901'), 
(103, 'Noluthando', 'Ncube', 'nolu.ncube@gmail.com', '068-678-9012')



/*6. Creating Orders table*/
create table Orders(
OrderID int primary key,
CustomerID int foreign Key references Customers(CustomerID), 
OrderDate date,
TotalAmount float
);

/*7. Inserting into Orders table*/
insert into Orders values
(001, 101, '2024-07-01', 600.00),
(002, 102, '2024-07-02', 300.00), 
(003, 103, '2024-07-03', 150.00)



/*8. Creating OrderItems table*/
create table OrderItems(
OrderItemID int Primary key,
OrderID int foreign key references Orders(OrderID),
ItemID int foreign key references Items(ItemID), 
Quantity int,
LineTotal float
);

/*9. Inserting into OrderItems table*/
insert into OrderItems values
(001, 001, 001, 2, 600.00),
(002, 001, 003, 5, 50.00), 
(003, 002, 002, 2, 300.00), 
(004, 003, 004, 10, 20.00)



/*10. Displaying all orders*/
select * from Orders



/*11. Update Items using a sub-query*/
update Items
set Price = Price * 1.10 where Category = 'Furniture'
select * from Items;



/*12. Order Summary by Item*/
Select 
    ItemID,
    SUM(StockQuantity) As total_quantity_sold,
    SUM(StockQuantity * Price) As total_revenue
From
    Items
Group By 
    ItemID



/*13. Stored Procedure for Best-Selling Item*/
create procedure Best_Selling_Item
As
Begin
    Set NoCount On;
    Select Top 1
        ItemName,
        SUM(StockQuantity * Price) As TotalSalesAmount
    From Items
    Group By ItemName
    Order By TotalSalesAmount DESC;
End;
Go
--SQL to execute the procedure
exec Best_Selling_Item



/*14. Order Summary by Customer*/
create procedure TotalSpent_ByCustomer
As
Begin
    Set NoCount On;
    Select
        c.CustomerID,
        c.FirstName,
        SUM(o.TotalAmount) As TotalAmountSpent
    From Customers c
    INNER JOIN Orders o 
        On c.CustomerID = o.CustomerID
    Group By c.CustomerID, c.FirstName
    Order By TotalAmountSpent DESC;
End;
Go
--SQL to execute the procedure
exec TotalSpent_ByCustomer



/*15. Customer with the Highest Orders*/
create view TopCustomer as
select 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(o.TotalAmount) As TotalAmount
From  
    Customers c
Join  
    Orders o On c.CustomerID = o.CustomerID
Group By 
    c.CustomerID, c.FirstName, c.LastName
Having 
    SUM(o.TotalAmount) = (
        Select MAX(Total_Per_Customer)
        From (
            Select SUM(TotalAmount) As Total_Per_Customer
            From Orders
            Group By CustomerID
        ) As totals
);
--SQL to display the view results
select * from TopCustomer;
