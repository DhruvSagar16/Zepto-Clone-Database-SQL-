--  3rd

--Yeh 5 steps help karta hai Role Based Access control ko implement karne

-- 1. CREATE SQL SERVER LOGINS WITH PASSWORDS
-- Note: Yeh Logins Server level pe bante hai na ki database level pe

CREATE LOGIN zeptoAdminLogin WITH password = 'admin@123';
CREATE LOGIN zeptoVendorLogin WITH password = 'vendor@123';


-- Humne jo Login banaye hai usse hume database users ko assign karna padta hai ,
--  isko hi hum Mapping bolte hai
-- 2. MAP LOGIN TO DATABASE USERS
USE zeptoDB;
CREATE USER admin_user FOR LOGIN zeptoAdminLogin;
CREATE USER vendor_user	FOR LOGIN zeptoVendorLogin;


-- 3. CREATE ROLES
CREATE ROLE AdminRole;
CREATE ROLE VendorRole;



-- 4. ASSIGN USERS TO ROLES

--1st method using ALTER
ALTER ROLE AdminRole ADD MEMBER admin_user;

--2nd method using Stored Procedure
EXEC sp_addrolemember 'VendorRole', 'vendor_user';


-- 5. GRANT / REVOKE PERMISSIONS TO ROLES
GRANT SELECT, INSERT, UPDATE, DELETE ON Users TO AdminRole;
GRANT SELECT, UPDATE ON Products TO AdminRole;

GRANT SELECT, UPDATE ON Inventory TO VendorRole;



REVOKE INSERT ON Users TO AdminRole;




--Use this on AdminLogin
Select * from Users;

INSERT INTO Users (FullName, Email, PhoneNumber, CreatedAt)
VALUES ('John Cena', 'john@cena.com', '9855445544',GETDATE());

--Use this on VendorLogin
select * from Inventory;

INSERT INTO Inventory (VendorID, ProductID, QuantityAvailable, LastUpdated)
VALUES (2, 3, 10, GETDATE());