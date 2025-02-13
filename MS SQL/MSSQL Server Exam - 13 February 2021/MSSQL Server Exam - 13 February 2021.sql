--	Section 1. DDL (30 pts)

CREATE DATABASE Bitbucket
USE Bitbucket

--	1.	Database Design

CREATE TABLE Users
(
Id INT PRIMARY KEY IDENTITY,
Username VARCHAR(30) NOT NULL,
[Password] VARCHAR(30) NOT NULL,
Email VARCHAR(50) NOT NULL
)

CREATE TABLE Repositories
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE RepositoriesContributors
(
RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) NOT NULL,
ContributorId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL,
PRIMARY KEY(RepositoryId, ContributorId)
)

CREATE TABLE Issues
(
Id INT PRIMARY KEY IDENTITY,
Title VARCHAR(255) NOT NULL,
IssueStatus CHAR(6) NOT NULL,
RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) NOT NULL,
AssigneeId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL
)

CREATE TABLE Commits
(
Id INT PRIMARY KEY IDENTITY,
[Message] VARCHAR(255) NOT NULL,
IssueId INT FOREIGN KEY REFERENCES Issues(Id),
RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) NOT NULL,
ContributorId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL
)

CREATE TABLE Files
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(100) NOT NULL,
Size DECIMAL(18, 2) NOT NULL,
ParentId INT FOREIGN KEY REFERENCES Files(Id),
CommitId INT FOREIGN KEY REFERENCES Commits(Id) NOT NULL
)

--	Section 2. DML (10 pts)

--	2.	Insert

INSERT INTO Files ([Name], Size, ParentId, CommitId)
VALUES
('Trade.idk', 2598.0, 1, 1),
('menu.net', 9238.31, 2, 2),
('Administrate.soshy', 1246.93,	3, 3),
('Controller.php', 7353.15, 4, 4),
('Find.java', 9957.86, 5, 5),
('Controller.json', 14034.87, 3, 6),
('Operate.xix', 7662.92, 7, 7)

INSERT INTO Issues (Title, IssueStatus, RepositoryId, AssigneeId)
VALUES
('Critical Problem with HomeController.cs file', 'open', 1, 4),
('Typo fix in Judge.html', 'open', 4, 3),
('Implement documentation for UsersService.cs', 'closed', 8, 2),
('Unreachable code in Index.cs', 'open', 9, 8)

--	3.	Update

UPDATE Issues SET IssueStatus = 'closed'
WHERE AssigneeId IN (6)

--	4.	Delete

DELETE FROM RepositoriesContributors
WHERE RepositoryId =
(SELECT Id FROM Repositories
WHERE [Name] = 'Softuni-Teamwork'
)

DELETE FROM Issues
WHERE RepositoryId = 
(
SELECT Id FROM Repositories
WHERE [Name] = 'Softuni-Teamwork'
)

--	Section 3. Querying (40 pts)

--	5.	Commits

SELECT Id, [Message], RepositoryId, ContributorId
FROM Commits
ORDER BY Id,[Message], RepositoryId, ContributorId

--	6.	Front-end

SELECT Id, [Name], Size
FROM Files
WHERE Size > 1000 AND [Name] LIKE '%html%'
ORDER BY Size DESC, Id, [Name]

--	7.	Issue Assignment

SELECT 
i.Id, 
CONCAT(u.Username, ' : ', i.Title) AS IssueAssignee
FROM Issues AS i
JOIN Users AS u ON i.AssigneeId = u.Id
ORDER BY i.Id DESC, i.AssigneeId

--	8.	Single Files

SELECT 
f.Id,
f.[Name],
CONCAT(f.Size, 'KB') AS Size
FROM Files AS f
LEFT JOIN Files AS fl ON fl.ParentId = f.Id
WHERE fl.ParentId IS NULL
ORDER BY f.Id, f.[Name], f.Size DESC

--	9.	Commits in Repositories

SELECT TOP (5)
r.Id,
r.[Name],
COUNT(c.Id) AS Commits
FROM Repositories AS r
JOIN Commits AS c ON r.Id = c.RepositoryId
JOIN RepositoriesContributors AS rc ON rc.RepositoryId = r.Id
GROUP BY r.[Name], r.Id
ORDER BY Commits DESC, r.Id, r.[Name]

--	10.	Average Size

SELECT u.Username, AVG(f.Size) AS Size
FROM Users AS u
JOIN Commits AS c ON u.Id = c.ContributorId
JOIN Files AS f ON f.CommitId = c.Id
GROUP BY u.Username
ORDER BY Size DESC, u.Username

--	Section 4. Programmability (20 pts)

--	11.	All User Commits

GO

CREATE FUNCTION udf_AllUserCommits(@username VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @output INT =
	(
	SELECT COUNT(c.[Message])
	FROM Commits AS c
	JOIN Users AS u ON c.ContributorId = u.Id
	WHERE u.Username = @username
		
	)
	RETURN @output
END

GO
	-- SELECT dbo.udf_AllUserCommits('UnderSinduxrein')

	--	12.	 Search for Files
	
	CREATE PROCEDURE usp_SearchForFiles(@fileExtension VARCHAR(20))
	AS
	BEGIN
		SELECT 
		Id,
		[Name],
		CONCAT(Size, 'KB') AS Size
		FROM Files AS f
		WHERE [Name] LIKE CONCAT('%', @fileExtension)
		ORDER BY Id, [Name], f.Size DESC
	END

	GO

	-- EXEC usp_SearchForFiles 'txt'