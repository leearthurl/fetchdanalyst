USE [fetchdanalyst];

--What are the top 5 brands by receipts scanned for most recent month?
CREATE TABLE tmp (
	oid NVARCHAR(MAX),
	dateScanned DATE,
	brandCode NVARCHAR(MAX),
	[description] NVARCHAR(MAX),
	rewardsGroup NVARCHAR(MAX),
	rewardsReceiptStatus VARCHAR(8)
);
INSERT INTO tmp(oid, dateScanned, brandCode, [description], rewardsGroup, rewardsReceiptStatus)
	SELECT oid, dateScanned, brandCode, [description], rewardsGroup, rewardsReceiptStatus FROM receipts
		WHERE brandCode IS NOT NULL OR [description] IS NOT NULL OR rewardsGroup IS NOT NULL;
WITH tmpDeleteDuplicate AS (SELECT oid, dateScanned, brandCode, [description], rewardsGroup, rewardsReceiptStatus, ROW_NUMBER() OVER (PARTITION BY oid, dateScanned, brandCode, [description], rewardsGroup ORDER BY dateScanned) AS ROW_COUNT FROM tmp)
	DELETE FROM tmpDeleteDuplicate WHERE ROW_COUNT > 1;

--TOP brandCodes per unique receipt for Feb 2021
SELECT TOP 5 YEAR(dateScanned) AS yearScanned, MONTH(dateScanned) AS monthScanned, brandCode, COUNT(brandCode) AS receiptsScanned FROM tmp
	WHERE YEAR(dateScanned) = 2021 AND MONTH(dateScanned) = 02 AND (brandCode IS NOT NULL AND brandCode != 'BRAND') AND rewardsReceiptStatus = 'FINISHED'
	GROUP BY YEAR(dateScanned), MONTH(dateScanned), brandCode ORDER BY COUNT(brandCode) DESC;

--How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
--TOP brandCodes per unique receipt for Jan 2021
SELECT TOP 5 YEAR(dateScanned) AS yearScanned, MONTH(dateScanned) AS monthScanned, brandCode, COUNT(brandCode) AS receiptsScanned FROM tmp
	WHERE YEAR(dateScanned) = 2021 AND MONTH(dateScanned) = 01 AND (brandCode IS NOT NULL AND brandCode != 'BRAND') AND rewardsReceiptStatus = 'FINISHED'
	GROUP BY YEAR(dateScanned), MONTH(dateScanned), brandCode ORDER BY COUNT(brandCode) DESC;

DROP TABLE IF EXISTS tmp;