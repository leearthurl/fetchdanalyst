USE [fetchdanalyst];

--When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
--When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
CREATE TABLE tmp (
	oid NVARCHAR(MAX),
	quantityPurchased INT,
	rewardsReceiptStatus VARCHAR(8),
	totalSpent FLOAT
);
INSERT INTO tmp(oid, quantityPurchased, rewardsReceiptStatus, totalSpent)
	SELECT oid, SUM(quantityPurchased) AS quantityPurchased, rewardsReceiptStatus, totalSpent FROM receipts
		GROUP BY oid, rewardsReceiptStatus, totalSpent;
SELECT AVG(totalSpent) AS averageSpend, AVG(quantityPurchased) AS averageTotalQuantity FROM tmp WHERE rewardsReceiptStatus = 'FINISHED';
SELECT AVG(totalSpent) AS averageSpend, AVG(quantityPurchased) AS averageTotalQuantity FROM tmp WHERE rewardsReceiptStatus = 'REJECTED';

DROP TABLE IF EXISTS tmp;

--Using purchasedItemCount instead of SUM(quantityPurchased) gets same results
CREATE TABLE tmp (
	oid NVARCHAR(MAX),
	purchasedItemCount INT,
	rewardsReceiptStatus VARCHAR(8),
	totalSpent FLOAT
);
INSERT INTO tmp(oid, purchasedItemCount, rewardsReceiptStatus, totalSpent)
	SELECT oid, purchasedItemCount, rewardsReceiptStatus, totalSpent FROM receipts
		GROUP BY oid, purchasedItemCount, rewardsReceiptStatus, totalSpent;
SELECT AVG(totalSpent) AS averageSpend, AVG(purchasedItemCount) AS averageTotalQuantity FROM tmp WHERE rewardsReceiptStatus = 'FINISHED';
SELECT AVG(totalSpent) AS averageSpend, AVG(purchasedItemCount) AS averageTotalQuantity FROM tmp WHERE rewardsReceiptStatus = 'REJECTED';

DROP TABLE IF EXISTS tmp;


--Which brand has the most spend among users who were created within the past 6 months?
CREATE TABLE tmp (
	oid NVARCHAR(MAX),
	brandCode NVARCHAR(MAX),
	[description] NVARCHAR(MAX),
	finalPrice FLOAT,
	rewardsGroup NVARCHAR(MAX),
	userId NVARCHAR(MAX),
	createdDate DATE
);
INSERT INTO tmp(oid, brandCode, [description], finalPrice, rewardsGroup, userId, createdDate)
	SELECT r.oid, r.brandCode, r.[description], r.finalPrice, r.rewardsGroup, r.userId, u.createdDate FROM receipts r
	FULL OUTER JOIN usersUnique u ON r.userId = u.oid
	WHERE brandCode IS NOT NULL OR [description] IS NOT NULL OR rewardsGroup IS NOT NULL;
WITH tmpDeleteDuplicate AS (SELECT oid, brandCode, [description], finalPrice, rewardsGroup, userId, createdDate, ROW_NUMBER() OVER (PARTITION BY oid, brandCode, [description], finalPrice, rewardsGroup, userId, createdDate ORDER BY createdDate) AS ROW_COUNT FROM tmp)
	DELETE FROM tmpDeleteDuplicate WHERE ROW_COUNT > 1;
SELECT TOP 1 brandCode, SUM(finalPrice) AS totalSpend FROM tmp
	WHERE brandCode IS NOT NULL AND createdDate BETWEEN '2020-09-01' AND '2021-02-28' GROUP BY brandCode ORDER BY SUM(finalPrice) DESC;
--Which brand has the most transactions among users who were created within the past 6 months?
SELECT TOP 1 brandCode, COUNT(oid) AS totalTransactions FROM tmp
	WHERE brandCode IS NOT NULL AND createdDate BETWEEN '2020-09-01' AND '2021-02-28' GROUP BY brandCode ORDER BY COUNT(oid) DESC;

DROP TABLE IF EXISTS tmp;