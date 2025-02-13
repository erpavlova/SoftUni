CREATE DATABASE WMS
USE WMS

--	Section 1. DDL

CREATE TABLE [Clients](
    [ClientId] INT PRIMARY KEY IDENTITY NOT NULL,
    [FirstName] VARCHAR(50) NOT NULL,
    [LastName] VARCHAR(50) NOT NULL,
    [Phone] CHAR(12) NOT NULL,
    CHECK (LEN([Phone]) = 12)
)
 
CREATE TABLE [Mechanics](
    [MechanicId] INT PRIMARY KEY IDENTITY NOT NULL,
    [FirstName] VARCHAR(50) NOT NULL,
    [LastName] VARCHAR(50) NOT NULL,
    [Address] VARCHAR(255) NOT NULL
)
 
CREATE TABLE [Models](
    [ModelId] INT PRIMARY KEY IDENTITY NOT NULL,
    [Name] VARCHAR(50) NOT NULL UNIQUE
)
 
CREATE TABLE [Jobs](
    [JobId] INT PRIMARY KEY IDENTITY NOT NULL,
    [ModelId] INT FOREIGN KEY REFERENCES [Models]([ModelId]) NOT NULL,
    [Status] VARCHAR(11) NOT NULL DEFAULT('Pending'),
    [ClientId] INT FOREIGN KEY REFERENCES [Clients]([ClientId]) NOT NULL,
    [MechanicId] INT FOREIGN KEY REFERENCES [Mechanics]([MechanicId]),
    [IssueDate] DATE NOT NULL,
    [FinishDate] DATE,
    CHECK ([Status] IN ('Pending', 'In Progress', 'Finished'))
)
 
CREATE TABLE [Orders](
    [OrderId] INT PRIMARY KEY IDENTITY NOT NULL,
    [JobId] INT FOREIGN KEY REFERENCES [Jobs]([JobId]) NOT NULL,
    [IssueDate] DATE,
    [Delivered] BIT NOT NULL DEFAULT(0)
)
 
CREATE TABLE [Vendors](
    [VendorId] INT PRIMARY KEY IDENTITY NOT NULL,
    [Name] VARCHAR(50) NOT NULL UNIQUE
)
 
CREATE TABLE [Parts](
    [PartId] INT PRIMARY KEY IDENTITY NOT NULL,
    [SerialNumber] VARCHAR(50) NOT NULL UNIQUE,
    [Description] VARCHAR(255),
    [Price] DECIMAL(6, 2) NOT NULL,
    [VendorId] INT FOREIGN KEY REFERENCES [Vendors]([VendorId]) NOT NULL,
    [StockQty] INT NOT NULL DEFAULT(0),
    CHECK ([Price] > 0),
    CHECK ([StockQty] >= 0)
)
 
CREATE TABLE [OrderParts](
    [OrderId] INT FOREIGN KEY REFERENCES [Orders]([OrderId]) NOT NULL,
    [PartId] INT FOREIGN KEY REFERENCES [Parts]([PartId]) NOT NULL,
    [Quantity] INT NOT NULL DEFAULT(1),
    PRIMARY KEY([OrderId], [PartId]),
    CHECK([Quantity] > 0)
)
 
CREATE TABLE [PartsNeeded](
    [JobId] INT FOREIGN KEY REFERENCES [Jobs]([JobId]) NOT NULL,
    [PartId] INT FOREIGN KEY REFERENCES [Parts]([PartId]) NOT NULL,
    [Quantity] INT NOT NULL DEFAULT(1),
    PRIMARY KEY([JobId], [PartId]),
    CHECK([Quantity] > 0)
)

--	2.	Insert

INSERT INTO [Clients]([FirstName], [LastName], [Phone])
VALUES
('Teri', 'Ennaco', '570-889-5187'),
('Merlyn', 'Lawler', '201-588-7810'),
('Georgene' ,'Montezuma'    ,'925-615-5185'),
('Jettie'   ,'Mconnell' ,'908-802-3564'),
('Lemuel' ,'Latzke  ','631-748-6479'),
('Melodie'  ,'Knipp',   '805-690-1682'),
('Candida'  ,'Corbley'  ,'908-275-8357')
 
INSERT INTO [Parts]([SerialNumber], [Description], [Price], [VendorId])
VALUES
('WP8182119', 'Door Boot Seal', 117.86, 2),
('W10780048',   'Suspension Rod',   42.81, 1),
('W10841140', 'Silicone Adhesive' , 6.77, 4),
('WPY055980',   'High Temperature Adhesive',    13.94, 3)

--	03. Update

UPDATE Jobs
	  SET MechanicId   = (SELECT M.MechanicId 
						  FROM   Mechanics AS M
						  WHERE  M.FirstName = 'Ryan' AND M.LastName = 'Harnos'),  
			[Status]   = 'In Progress' 
	  WHERE [Status]   = 'Pending';


--	04. Delete

DELETE FROM OrderParts  WHERE OrderId = 19
DELETE FROM Orders  WHERE OrderId = 19

--	Section 3. Querying

--	5.	Mechanic Assignments

SELECT CONCAT(m.[FirstName], ' ', m.[LastName]) AS [Mechanic],
         j.[Status],
         j.[IssueDate]
    FROM [Mechanics] AS m
    JOIN [Jobs] AS j
      ON m.[MechanicId] = j.[MechanicId]
ORDER BY m.[MechanicId], j.[IssueDate], j.[JobId]

--	06. Current Clients

SELECT CONCAT(C.FirstName,' ',C.LastName), DATEDIFF(DAY, J.IssueDate, '2017-04-24') AS 'Days going', J.Status
FROM Jobs    AS J
JOIN Clients AS C ON C.ClientId = J.ClientId
WHERE J.Status != 'Finished'
ORDER BY DATEDIFF(DAY, J.IssueDate, '2017-04-24') DESC,
		 C.ClientId ASC

	--	7.	Mechanic Performance

		 SELECT [Mechanic],
         AVG([DaysWorked]) AS [Average Days]
		  FROM (
              SELECT m.[MechanicId],
                     CONCAT(m.[FirstName], ' ', m.[LastName]) AS [Mechanic],
                     j.[JobId],
                     DATEDIFF(DAY, j.[IssueDate], j.[FinishDate]) AS [DaysWorked]
                FROM [Mechanics] AS m
                JOIN [Jobs] AS j
                  ON m.[MechanicId] = j.[MechanicId]
               WHERE j.[Status] = 'Finished'
          ) AS [DaysWorkedSubQuery]
	GROUP BY [Mechanic], [MechanicId]
	ORDER BY [MechanicId]

	--	8.	Available Mechanics

	---Very hard way
SELECT CONCAT([FirstName], ' ', [LastName]) AS [Available]
FROM (
        SELECT m1.[MechanicId], [FirstName], [LastName],
                  (SELECT COUNT(*) FROM [Mechanics] AS m
                    LEFT JOIN [Jobs] AS j
                    ON m.[MechanicId] = j.[MechanicId]
                    WHERE m.[MechanicId] = m1.[MechanicId]
                  ) AS [All Jobs Count],
                  (SELECT COUNT(*) FROM [Mechanics] AS m
                    LEFT JOIN [Jobs] AS j
                    ON m.[MechanicId] = j.[MechanicId]
                    WHERE m.[MechanicId] = m1.[MechanicId] AND (j.[Status] = 'Finished' OR j.[Status] IS NULL)
                  ) AS [Finished Jobs Count]
             FROM [Mechanics] AS m1
        LEFT JOIN [Jobs] AS j
               ON m1.[MechanicId] = j.[MechanicId]
     ) AS [JobsCountSubQuery]
WHERE [All Jobs Count] = [Finished Jobs Count]
GROUP BY [FirstName], [LastName], [MechanicId]
ORDER BY [MechanicId]
 
---Very simple way
SELECT CONCAT([FirstName], ' ',[LastName]) AS [Available] 
  FROM [Mechanics]
 WHERE [MechanicId] NOT IN (
                                SELECT [MechanicId] FROM [Jobs]
                                WHERE [Status] = 'In Progress' 
                                GROUP BY [MechanicId]
                            )

	--	9.	Past Expenses

SELECT j.[JobId],
     ISNULL(SUM(p.[Price] * op.[Quantity]), 0) AS [Total]
FROM [Jobs] AS j
LEFT JOIN [Orders] AS o
ON j.[JobId] = o.[JobId]
LEFT JOIN [OrderParts] AS op
ON o.[OrderId] = op.[OrderId]
LEFT JOIN [Parts] AS p
ON op.[PartId] = p.[PartId]
WHERE j.[Status] = 'Finished'
GROUP BY j.[JobId]
ORDER BY [Total] DESC, j.[JobId]

--	10.	Missing Parts

SELECT *
FROM (
        SELECT p.[PartId],
               p.[Description],
               pn.[Quantity] AS [Required],
               p.[StockQty] AS [In Stock],
               ISNULL(op.[Quantity], 0) AS [Ordered]
        FROM [Jobs] AS j
        LEFT JOIN [PartsNeeded] AS pn
        ON j.[JobId] = pn.[JobId]
        LEFT JOIN [Parts] AS p
        ON pn.[PartId] = p.[PartId]
        LEFT JOIN [Orders] AS o
        ON j.[JobId] = o.[JobId]
        LEFT JOIN [OrderParts] AS op
        ON o.[OrderId] = op.[OrderId]
        WHERE j.[Status] <> 'Finished' AND (o.[Delivered] = 0 OR o.Delivered IS NULL)
     ) AS [PartsQuantitySubQuery]
WHERE [Required] > [In Stock] + [Ordered]
ORDER BY [PartId]

--	Section 4. Programmability

--	11.	Place Order

GO

-- Solution works for the result, issue with Judge!

CREATE  PROCEDURE usp_PlaceOrder (@JobID INT, @PartSerialNumber VARCHAR(50), @Qty INT) 
AS

DECLARE @Status VARCHAR(10) = (SELECT [Status] FROM Jobs WHERE JobId = @JobID)
DECLARE @PartId VARCHAR(10) = (SELECT PartId FROM Parts WHERE SerialNumber = @PartSerialNumber)

IF ( @Qty <= 0 )
    THROW 50012, 'Part quantity must be more than zero!', 1
ELSE IF (@Status IS NULL)
       THROW 500013, 'Job not found!', 1
ELSE IF (@Status = 'Finished')
    THROW 50012, 'This job is not active!',1
ELSE IF (@PartId IS NULL)
    THROW 500014, 'Part not found!', 1

DECLARE @OrderId INT  =  (SELECT OrderId  FROM Orders   WHERE JobId = @JobID AND IssueDate IS NULL)      
                                                    
IF @OrderId IS NULL     
BEGIN
    INSERT INTO Orders (JobId, IssueDate) VALUES  (@JobID, NULL)
END

SET @OrderId = (SELECT OrderId FROM Orders WHERE JobId = @JobID AND IssueDate IS NULL)                                 

DECLARE @OrderPartExist INT = (SELECT OrderId FROM OrderParts WHERE OrderId = @OrderId AND PartId = @PartId)              

IF @OrderPartExist IS NULL
BEGIN
    INSERT INTO OrderParts (OrderId, PartId, Quantity) VALUES   (@PartId, @OrderId, @Qty)
END
ELSE 
BEGIN
    UPDATE OrderParts
    SET Quantity+=@Qty
    WHERE OrderId = @OrderId AND PartId = @PartId
END
GO

-- Solution Test 

DECLARE @err_msg AS NVARCHAR(MAX);
BEGIN TRY
  EXEC usp_PlaceOrder 1, 'ZeroQuantity', 0
END TRY

BEGIN CATCH
  SET @err_msg = ERROR_MESSAGE();
  SELECT @err_msg
END CATCH

--	12.	Cost Of Order
GO

CREATE FUNCTION udf_GetCost (@jobId INT)
RETURNS DECIMAL(8, 2)
AS
BEGIN
    DECLARE @totalCost DECIMAL(8, 2)
 
    DECLARE @jobOrdersCount INT = (SELECT COUNT(OrderId) FROM [Jobs] AS j
                                    LEFT JOIN [Orders] AS o
                                    ON j.[JobId] = o.[JobId]
                                    WHERE j.[JobId] = @jobId
                                  )
    
    IF @jobOrdersCount = 0
    BEGIN
        RETURN 0
    END
 
    SET @totalCost =   (SELECT SUM(p.[Price] * op.[Quantity]) FROM [Jobs] AS j
                        LEFT JOIN [Orders] AS o
                        ON j.[JobId] = o.[JobId]
                        LEFT JOIN [OrderParts] AS op
                        ON o.[OrderId] = op.[OrderId]
                        LEFT JOIN [Parts] AS p
                        ON op.[PartId] = p.[PartId]
                        WHERE j.[JobId] = @jobId
                       )
 
    RETURN @totalCost
END
