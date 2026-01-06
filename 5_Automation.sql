-- 4th

CREATE TABLE Notifications (
	NotificationID INT IDENTITY(1,1) PRIMARY KEY,
	Message NVARCHAR(255),
	ScheduledTime TIME,
	DayOfWeek NVARCHAR(10),
	CreatedAT DATETIME DEFAULT GETDATE()
);

INSERT INTO Notifications (Message, ScheduledTime, DayOfWeek)
VALUES 
('Samosa Time? Do not be shy!', '09:00:00', 'Sunday'),
('Pyar ek bar nahi hota... par icecream roz khayi ja sakti hai!', '15:00:00', 'Saturday'),
('Hot outside? Let us have a coke', '13:00:00', 'Monday'),
('Lal pari neli pari kamre mai band hai mujhe Biryani pasand hai', '19:00:00', 'Tuesday');

select * from Notifications;



CREATE PROCEDURE sp_SendNotification
AS 
BEGIN
	DECLARE @Today NVARCHAR(10) = DATENAME(WEEKDAY, GETDATE());
	DECLARE @CurrentTime TIME = CAST(GETDATE() AS TIME);

	SELECT n.Message FROM Notifications as n 
	WHERE n.DayOfWeek = @Today 
	AND n.ScheduledTime <= @CurrentTime
	AND n.ScheduledTime >= DATEADD(MINUTE, -1, @CurrentTime);
END;

EXEC sp_SendNotification;

