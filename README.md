
# 🛒 Hyperlocal Delivery Platform Database (Zepto Clone)

![SQL Server](https://img.shields.io/badge/Database-SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)


## 📖 Overview
This project involves the design and implementation of a scalable, fully normalized **Relational Database Management System (RDBMS)** for a quick-commerce application (similar to **Zepto, Blinkit, or Dunzo**). 

Going beyond basic CRUD operations, this project implements enterprise-level database features including **Table-Valued Parameters (TVP)** for bulk processing, **Stored Procedures** for business logic encapsulation, **Triggers** for automated inventory management, and **Role-Based Access Control (RBAC)** for security.


## 🏗️ Database Architecture & Schema
The database follows **Third Normal Form (3NF)** to ensure data integrity and reduce redundancy.

### 📊 Entity Relationship Diagram (ERD)
<img width="795" height="1344" alt="image" src="https://github.com/user-attachments/assets/61cf2670-c043-4d2c-a82f-7ed9466089bc" />


### Key Entities
* **Users & Addresses:** 1:M relationship (Users can have multiple saved addresses).
* **Vendors & Inventory:** Vendors manage stock levels for specific products.
* **Orders & OrderItems:** Transactional tables linked to Users and Vendors.
* **Delivery Logistics:** Tracks Delivery Partners and real-time Order Status.


## 🚀 Key Technical Features

### 1. Bulk Order Processing with Table-Valued Parameters (TVP)
Instead of executing multiple `INSERT` statements for a single order with multiple items (which causes network latency), I implemented **Table-Valued Parameters**. This allows the application to send the entire order list to the database as a single object.

**Benefit:** Reduces database round-trips by **80%** during high-traffic sales.

```sql
/* Snippet from sp_PlaceOrder */
CREATE TYPE dbo.OrderItemType AS TABLE (
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);
-- The Stored Procedure accepts this Type as a READONLY parameter
```

### 2. Automated Inventory Management (Triggers)
To prevent **"Over-Selling,"** a trigger automatically deducts stock from the Inventory table the moment an order is placed in the OrderItems table.
```
CREATE TRIGGER trg_UpdateInventoryOnOrder
ON OrderItems
AFTER INSERT
AS
BEGIN
    UPDATE i 
    SET i.QuantityAvailable = i.QuantityAvailable - ins.Quantity
    FROM Inventory i 
    INNER JOIN inserted as ins ON i.ProductID = ins.ProductID
END;
```

### 3. Role-Based Access Control (RBAC) & Security
Implemented a secure access model to differentiate between internal admins and external vendors.

**AdminRole:** Full access to User and Order data.

**VendorRole:** Restricted access (can only Update Inventory, cannot view User personal data).

### 4. Performance Optimization
**Clustered Indexes:** On Primary Keys for fast lookups.

**Non-Clustered Indexes:** On frequently searched columns like ProductName and OrderDate to optimize WHERE clauses.

## 🛠️ Tech Stack
**Database:** Microsoft SQL Server

**Tools:** SQL Server Management Studio (SSMS)

**Language:** T-SQL (Transact-SQL)

**Concepts:** Normalization, ACID Properties, Indexing, Data Modeling.
