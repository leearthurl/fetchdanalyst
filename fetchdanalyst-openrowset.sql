USE [fetchdanalyst];

DECLARE @JSON NVARCHAR(MAX)

SELECT @JSON=BulkColumn
FROM OPENROWSET(BULK 'C:\Users\Arthur\Documents\SQL Server Management Studio\fetchdanalyst\brands.json', SINGLE_CLOB) import

INSERT INTO brands(oid, barcode, brandCode, category, categoryCode, cpgoid, cpgref, [name], topBrand)
SELECT
	C.value AS oid,
	B.barcode,
	B.brandCode,
	B.category,
	B.categoryCode,
	SUBSTRING(D.value, 10, 24) AS cpgoid,
	E.value AS cpgref,
	B.[name],
	B.topBrand
FROM OPENJSON(@json)
WITH (
	brands NVARCHAR(MAX) AS JSON
	) A
OUTER APPLY OPENJSON(A.brands)
WITH (
	_id NVARCHAR(MAX) AS JSON,
	barcode VARCHAR(13),
	brandCode VARCHAR(46),
	category VARCHAR(27),
	categoryCode VARCHAR(29),
	cpg NVARCHAR(MAX) AS JSON,
	[name] VARCHAR(57),
	topBrand BIT
	) B
OUTER APPLY OPENJSON(B._id) C
OUTER APPLY OPENJSON(B.cpg) D
OUTER APPLY OPENJSON(B.cpg) E
WHERE D.[key] = '$id' AND E.[key] = '$ref';


SELECT @JSON=BulkColumn
FROM OPENROWSET(BULK 'C:\Users\Arthur\Documents\SQL Server Management Studio\fetchdanalyst\receipts.json', SINGLE_CLOB) import

INSERT INTO receipts(oid, bonusPointsEarned, B.bonusPointsEarnedReason, createDateUnix, dateScannedUnix, finishedDateUnix, modifyDateUnix, pointsAwardedDateUnix, totalPointsEarned, purchaseDateUnix, purchasedItemCount, item, barcode, brandCode, competitorRewardsGroup, [description], discountedItemPrice, finalPrice, itemPrice, metabriteCampaignId, needsFetchReview, originalReceiptItemText, partnerItemId, pointsEarned, pointsNotAwardedReason, pointsPayerId, preventTargetGapPoints, quantityPurchased, rewardsGroup, rewardsProductPartnerId, userFlaggedBarcode, userFlaggedNewItem, userFlaggedPrice, userFlaggedQuantity, rewardsReceiptStatus, totalSpent, userId)
SELECT
	C.value AS oid,
	B.bonusPointsEarned,
	B.bonusPointsEarnedReason,
	D.value AS createDateUnix,
	E.value AS dateScannedUnix,
	F.value AS finishedDateUnix,
	G.value AS modifyDateUnix,
	H.value AS pointsAwardedDateUnix,
	B.pointsEarned AS totalPointsEarned,
	I.value AS purchaseDateUnix,
	B.purchasedItemCount,
	J.[key] AS item,
	JSON_VALUE(J.value, '$.barcode') AS barcode,
	JSON_VALUE(J.value, '$.brandCode') AS brandCode,
	JSON_VALUE(J.value, '$.competitorRewardsGroup') AS competitorRewardsGroup,
	JSON_VALUE(J.value, '$.description') AS [description],
	JSON_VALUE(J.value, '$.discountedItemPrice') AS discountedItemPrice,
	JSON_VALUE(J.value, '$.finalPrice') AS finalPrice,
	JSON_VALUE(J.value, '$.itemPrice') AS itemPrice,
	JSON_VALUE(J.value, '$.metabriteCampaignId') AS metabriteCampaignId,
	JSON_VALUE(J.value, '$.needsFetchReview') AS needsFetchReview,
	JSON_VALUE(J.value, '$.originalReceiptItemText') AS originalReceiptItemText,
	JSON_VALUE(J.value, '$.partnerItemId') AS partnerItemId,
	JSON_VALUE(J.value, '$.pointsEarned') AS pointsEarned,
	JSON_VALUE(J.value, '$.pointsNotAwardedReason') AS pointsNotAwardedReason,
	JSON_VALUE(J.value, '$.pointsPayerId') AS pointsPayerId,
	JSON_VALUE(J.value, '$.preventTargetGapPoints') AS preventTargetGapPoints,
	JSON_VALUE(J.value, '$.quantityPurchased') AS quantityPurchased,
	JSON_VALUE(J.value, '$.rewardsGroup') AS rewardsGroup,
	JSON_VALUE(J.value, '$.rewardsProductPartnerId') AS rewardsProductPartnerId,
	JSON_VALUE(J.value, '$.userFlaggedBarcode') AS userFlaggedBarcode,
	JSON_VALUE(J.value, '$.userFlaggedNewItem') AS userFlaggedNewItem,
	JSON_VALUE(J.value, '$.userFlaggedPrice') AS userFlaggedPrice,
	JSON_VALUE(J.value, '$.userFlaggedQuantity') AS userFlaggedQuantity,
	B.rewardsReceiptStatus,
	B.totalSpent,
	B.userId
FROM OPENJSON(@json)
WITH (
	receipts NVARCHAR(MAX) AS JSON
	) A
OUTER APPLY OPENJSON(A.receipts)
WITH (
	_id NVARCHAR(MAX) AS JSON,
	bonusPointsEarned INT,
	bonusPointsEarnedReason VARCHAR(128),
	createDate NVARCHAR(MAX) AS JSON,
	dateScanned NVARCHAR(MAX) AS JSON,
	finishedDate NVARCHAR(MAX) AS JSON,
	modifyDate NVARCHAR(MAX) AS JSON,
	pointsAwardedDate NVARCHAR(MAX) AS JSON,
	pointsEarned FLOAT,
	purchaseDate NVARCHAR(MAX) AS JSON,
	purchasedItemCount INT,
	rewardsReceiptItemList NVARCHAR(MAX) AS JSON,
	rewardsReceiptStatus VARCHAR(8),
	totalSpent FLOAT,
	userId NVARCHAR(MAX)
	) B
OUTER APPLY OPENJSON(B._id) C
OUTER APPLY OPENJSON(B.createDate) D
OUTER APPLY OPENJSON(B.dateScanned) E
OUTER APPLY OPENJSON(B.finishedDate) F
OUTER APPLY OPENJSON(B.modifyDate) G
OUTER APPLY OPENJSON(B.pointsAwardedDate) H
OUTER APPLY OPENJSON(B.purchaseDate) I
OUTER APPLY OPENJSON(B.rewardsReceiptItemList) J;


SELECT @JSON=BulkColumn
FROM OPENROWSET(BULK 'C:\Users\Arthur\Documents\SQL Server Management Studio\fetchdanalyst\users.json', SINGLE_CLOB) import

INSERT INTO users(oid, active, createdDateUnix, lastLoginUnix, [role], signUpSource, [state])
SELECT
	C.value AS oid,
	B.active,
	D.value AS createdDateUnix,
	E.value AS lastLoginUnix,
	B.[role],
	B.signUpSource,
	B.[state]
FROM OPENJSON(@json)
WITH (
	users NVARCHAR(MAX) AS JSON
	) A
OUTER APPLY OPENJSON(A.users)
WITH (
	_id NVARCHAR(MAX) AS JSON,
	active BIT,
	createdDate NVARCHAR(MAX) AS JSON,
	lastLogin NVARCHAR(MAX) AS JSON,
	[role] VARCHAR(11),
	signUpSource VARCHAR(6),
	[state] VARCHAR(2)
	) B
OUTER APPLY OPENJSON(B._id) C
OUTER APPLY OPENJSON(B.createdDate) D
OUTER APPLY OPENJSON(B.lastLogin) E;