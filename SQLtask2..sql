CREATE VIEW BlogUserDetails AS
SELECT b.Title, u.UserName, u.FullName
FROM Blogs b
JOIN Users u ON b.UserId = u.Id;

CREATE VIEW BlogCategoryDetails AS
SELECT b.Title, c.Name AS CategoryName
FROM Blogs b
JOIN Categories c ON b.CategoryId = c.Id;

CREATE PROCEDURE GetUserComments(@userId INT)
AS
BEGIN
    SELECT c.Id, c.Content, c.BlogId
    FROM Comments c
    WHERE c.UserId = @userId;
END;

CREATE PROCEDURE GetUserBlogs(@userId INT)
AS
BEGIN
    SELECT b.Id, b.Title, b.Description, b.CategoryId
    FROM Blogs b
    WHERE b.UserId = @userId;
END;

CREATE FUNCTION GetBlogCountByCategory(@categoryId INT)
RETURNS INT
AS
BEGIN
    DECLARE @count INT;
    SELECT @count = COUNT(*)
    FROM Blogs
    WHERE CategoryId = @categoryId;
    RETURN @count;
END;

CREATE FUNCTION GetBlogsByUser(@userId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT b.Id, b.Title, b.Description, b.CategoryId
    FROM Blogs b
    WHERE b.UserId = @userId
);

CREATE TRIGGER MarkBlogAsDeleted
ON Blogs
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Blogs
    SET isDeleted = 1
    WHERE Id IN (SELECT Id FROM deleted);
END;
