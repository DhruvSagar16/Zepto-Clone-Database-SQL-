-- 2nd
-- Get the Order Summary detail
CREATE VIEW vw_OrderSummary AS
SELECT o.OrderID, u.FullName  as 'Customer Name' , v.VendorName 'VendorName',
o.OrderDate, o.TotalAmount, s.StatusName
FROM Orders o JOIN Users u ON o.UserID = u.UserID
JOIN Vendors v ON O.VendorID = v.VendorID
JOIN DeliveryStatus ds ON o.OrderID = ds.OrderID
JOIN Status s ON s.StatusID = ds.StatusID;

select * from vw_OrderSummary;


-- Product Sales Summary
CREATE VIEW vw_ProductSalesSummary AS
SELECT p.ProductName as 'Product Name', sum(oi.Quantity)  as 'Total Product Sold'
FROM OrderItems	oi JOIN Products p
ON oi.ProductID = p.ProductID
group by p.ProductName;


Select * from vw_ProductSalesSummary;


--Indexing 
CREATE NONCLUSTERED INDEX idx_ProductName ON Products(ProductName);

select * from Products where ProductName like '%2%';


CREATE NONCLUSTERED INDEX idx_OrderItems_Order_product 
ON OrderItems(OrderID, ProductID);


-- Triggers - automate the inventory stock automatically when product is ordered.
-- When orderitem in inserted then inventory quantity should be updated.
CREATE TRIGGER trg_UpdateInventoryOnOrder
ON OrderItems
AFTER INSERT
AS
BEGIN
	UPDATE i SET i.QuantityAvailable = i.QuantityAvailable - ins.Quantity
	FROM Inventory i INNER JOIN inserted as ins
	ON  i.ProductID = ins.ProductID
END;




-- Stored procedure- Place new order
 CREATE TYPE dbo.OrderItemType AS Table (
	ProductID INT,
	Quantity INT,
	Price DECIMAL(10,2)
);

CREATE PROCEDURE sp_PlaceOrder
@UserID INT, @VendorID INT, @TotalAmount Decimal(10,2), 
@OrderItemsList AS dbo.OrderItemType READONLY -- Pass multiple items (ProductID, Quantity, Price)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @NewOrderID INT;

	-- 1. Insert into orders Table
	INSERT INTO Orders(UserID, VendorID, OrderDate, TotalAmount)
	VALUES (@UserID, @VendorID, GETDATE(), @TotalAmount);

	-- 2. Get the newly created OrderID
	SET @NewOrderID = SCOPE_IDENTITY();

	-- 3. insert into orderitems table
	INSERT INTO OrderItems(OrderID, ProductID, Quantity, Price)
	SELECT @NewOrderID, ProductID, Quantity, Price FROM @OrderItemsList;
END;

SELECT * FROM INVENTORY WHERE ProductID = 1;

DECLARE @Items dbo.OrderItemType;

INSERT INTO @Items (ProductID, Quantity, Price) VALUES (1,4, 70.00);

EXEC sp_PlaceOrder 1, 2, 280, @Items;

SELECT * FROM Orders;