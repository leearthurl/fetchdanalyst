USE [fetchdanalyst];

--ALTER brands
CREATE TABLE brandsTrimmed (
	oid NVARCHAR(MAX),
	barcode VARCHAR(13) NOT NULL,
	brandCode VARCHAR(46),
	category VARCHAR(27),
	categoryCode VARCHAR(29),
	cpgoid NVARCHAR(MAX),
	cpgref NVARCHAR(MAX),
	[name] VARCHAR(57),
	topBrand BIT
);
INSERT INTO brandsTrimmed(oid, barcode, brandCode, category, categoryCode, cpgoid, cpgref, [name], topBrand) SELECT * FROM brands;
--DELETE duplicate barcodes rows in brandsTrimmed EXCEPT if matching brandCode exists
DELETE FROM brandsTrimmed WHERE barcode IN (SELECT barcode FROM brandsTrimmed GROUP BY barcode HAVING COUNT(barcode) > 1 EXCEPT SELECT barcode FROM receipts WHERE brandsTrimmed.brandCode = receipts.brandCode);

--ALTER brandsTrimmed.oid and receipts.barcode to lose NVARCHAR(MAX)
ALTER TABLE brandsTrimmed
ALTER COLUMN oid VARCHAR(24) NOT NULL;
ALTER TABLE receipts
ALTER COLUMN barcode VARCHAR(13);

--Set PK/FK brandsTrimmed/receipts
ALTER TABLE brandsTrimmed
ADD CONSTRAINT PK_brands PRIMARY KEY(barcode);
ALTER TABLE receipts WITH NOCHECK
ADD CONSTRAINT FK1_receipts FOREIGN KEY(barcode) REFERENCES brandsTrimmed(barcode);


--ALTER receipts
ALTER TABLE receipts
ALTER COLUMN quantityPurchased INT
ALTER TABLE receipts
ALTER COLUMN createDateUnix BIGINT
ALTER TABLE receipts
ALTER COLUMN dateScannedUnix BIGINT
ALTER TABLE receipts
ALTER COLUMN finishedDateUnix BIGINT
ALTER TABLE receipts
ALTER COLUMN modifyDateUnix BIGINT
ALTER TABLE receipts
ALTER COLUMN pointsAwardedDateUnix BIGINT
ALTER TABLE receipts
ALTER COLUMN purchaseDateUnix BIGINT
--UNIX Date Conversion
ALTER TABLE receipts
ADD createDate DATE
ALTER TABLE receipts
ADD dateScanned DATE
ALTER TABLE receipts
ADD finishedDate DATE
ALTER TABLE receipts
ADD modifyDate DATE
ALTER TABLE receipts
ADD pointsAwardedDate DATE
ALTER TABLE receipts
ADD purchaseDate DATE;

UPDATE receipts SET
	createDate = DATEADD(s, createDateUnix/1000, '1970-01-01'),
	dateScanned = DATEADD(s, dateScannedUnix/1000, '1970-01-01'),
	finishedDate = DATEADD(s, finishedDateUnix/1000, '1970-01-01'),
	modifyDate = DATEADD(s, modifyDateUnix/1000, '1970-01-01'),
	pointsAwardedDate = DATEADD(s, pointsAwardedDateUnix/1000, '1970-01-01'),
	purchaseDate = DATEADD(s, purchaseDateUnix/1000, '1970-01-01')
FROM receipts;
ALTER TABLE receipts
DROP COLUMN createDateUnix
ALTER TABLE receipts
DROP COLUMN dateScannedUnix
ALTER TABLE receipts
DROP COLUMN finishedDateUnix
ALTER TABLE receipts
DROP COLUMN modifyDateUnix
ALTER TABLE receipts
DROP COLUMN pointsAwardedDateUnix
ALTER TABLE receipts
DROP COLUMN purchaseDateUnix;


--ALTER users
ALTER TABLE users
ALTER COLUMN createdDateUnix BIGINT
ALTER TABLE users
ALTER COLUMN lastLoginUnix BIGINT
--UNIX Date Conversion
ALTER TABLE users
ADD createdDate DATE
ALTER TABLE users
ADD lastLogin DATE;

UPDATE users SET
	createdDate = DATEADD(s, createdDateUnix/1000, '1970-01-01'),
	lastLogin = DATEADD(s, lastLoginUnix/1000, '1970-01-01')
FROM users;
ALTER TABLE users
DROP COLUMN createdDateUnix
ALTER TABLE users
DROP COLUMN lastLoginUnix;
CREATE TABLE usersUnique (
	oid NVARCHAR(MAX) NOT NULL,
	active BIT,
	createdDate NVARCHAR(MAX),
	lastLogin NVARCHAR(MAX),
	[role] VARCHAR(11),
	signUpSource VARCHAR(6),
	[state] VARCHAR(2)
);
INSERT INTO usersUnique(oid, active, [role], signUpSource, [state], createdDate, lastLogin) SELECT * FROM users;
--DELETE duplicate oid rows in usersUnique
WITH usersDeleteDuplicate AS (SELECT oid, ROW_NUMBER() OVER (PARTITION BY oid ORDER BY oid) AS ROW_COUNT FROM usersUnique)
DELETE FROM usersDeleteDuplicate WHERE ROW_COUNT > 1;

--ALTER usersUnique.oid to lose NVARCHAR(MAX)
ALTER TABLE usersUnique
ALTER COLUMN oid VARCHAR(24) NOT NULL;

--Set PK/FK usersUnique/receipts
ALTER TABLE usersUnique
ADD CONSTRAINT PK_users PRIMARY KEY(oid);
ALTER TABLE receipts WITH NOCHECK
ADD CONSTRAINT FK2_receipts FOREIGN KEY(userID) REFERENCES usersUnique(oid);

--Data Annotation (WHERE rewardsReceiptStatus = 'FINISHED') for Feb 2021
UPDATE receipts SET brandCode = 'DRISCOLL''S' WHERE [description] = 'Berry Strawberry Conventional, 16 Ounce';
UPDATE receipts SET brandCode = 'SUAVE' WHERE rewardsGroup = 'SUAVE HAIR CARE';
UPDATE receipts SET brandCode = 'DORITOS' WHERE rewardsGroup = 'DORITOS SPICY SWEET CHILI SINGLE SERVE';
UPDATE receipts SET brandCode = 'TOTINO''S' WHERE rewardsGroup = 'TOTINO''S PARTY PIZZA - SINGLE PACK';
UPDATE receipts SET brandCode = 'CORN NUTS' WHERE [description] = 'CORN NUTS Chile Picante con Limon Crunchy Corn Kernels 1.7 OZ Bag';
UPDATE receipts SET brandCode = 'ZATARAIN''S' WHERE [description] = 'CJN INJ & LSN GLD GRLN KIT BOX 1 CT';
UPDATE receipts SET brandCode = 'SARGENTO' WHERE rewardsGroup = 'SARGENTO RICOTTA CHEESE';
UPDATE receipts SET brandCode = 'DUNCAN HINES' WHERE rewardsGroup = 'DUNCAN HINES CAKE MIX';
UPDATE receipts SET brandCode = 'HEINZ' WHERE rewardsGroup = 'HEINZ GRAVY - JAR';
UPDATE receipts SET brandCode = 'SARGENTO' WHERE rewardsGroup = 'SARGENTO NATURAL SHREDDED CHEESE 6OZ OR LARGER';
UPDATE receipts SET brandCode = 'SHEILA G''S' WHERE [description] =  'BROWNIE BRITLE';
UPDATE receipts SET brandCode = 'HEINZ' WHERE [description] = 'HEINZ SWEET SWEET RELISH 12.7 OZ - 0013000006184';
UPDATE receipts SET brandCode = 'CAPRI SUN' WHERE rewardsGroup = 'CAPRI SUN BEVERAGE DRINK';
UPDATE receipts SET brandCode = 'GEVALIA' WHERE rewardsGroup = 'GEVALIA KAFFE KEURIG COFFEE PODS';
UPDATE receipts SET brandCode = 'CAPRI SUN' WHERE rewardsGroup = 'CAPRI SUN FRUIT REFRESHERS BEVERAGE DRINK';
UPDATE receipts SET brandCode = 'PLANTERS' WHERE rewardsGroup = 'PLANTERS NUT-RITION MIXED NUTS';
UPDATE receipts SET brandCode = 'GULDEN''S' WHERE rewardsGroup = 'GULDENS MUSTARD';
UPDATE receipts SET brandCode = 'SWISS MISS' WHERE rewardsGroup = 'SWISS MISS CAFÉ';
UPDATE receipts SET brandCode = 'YOPLAIT' WHERE rewardsGroup = 'YOPLAIT FIBER ONE YOGURT';
UPDATE receipts SET brandCode = 'ANNIE''S' WHERE rewardsGroup = 'ANNIE''S HOMEGROWN MULTI-SERVING MAC & CHEESE';
UPDATE receipts SET brandCode = 'HUGGIES' WHERE rewardsGroup = 'HUGGIES ONE AND DONE SIMPLY CLEAN BABY WIPES 200 COUNT OR LARGER';
UPDATE receipts SET brandCode = 'COOKIE CRISP' WHERE rewardsGroup = 'COOKIE CRISP CEREAL FAMILY SIZE';
UPDATE receipts SET brandCode = 'DEVOUR' WHERE [description] = 'DEVOUR Bacon Topped Meatloaf with Spicy Ketchup 10.00-oz';
UPDATE receipts SET brandCode = 'KRAFT' WHERE rewardsGroup = 'JET-PUFFED MINI MARSHMALLOWS';
UPDATE receipts SET brandCode = 'SMART ONES' WHERE [description] = 'SMART ONES Stuffed Breakfast Sandwich 8.00-oz';
UPDATE receipts SET brandCode = 'KRAFT' WHERE [description] = 'KRAFT Catalina Dressing 24.00-fl oz';
UPDATE receipts SET brandCode = 'SUAVE' WHERE rewardsGroup = 'SUAVE KIDS HAIR CARE';
UPDATE receipts SET brandCode = 'CHEERIOS' WHERE rewardsGroup = 'HONEY NUT CHEERIOS CEREAL FAMILY SIZE';
UPDATE receipts SET brandCode = 'HUGGIES' WHERE rewardsGroup = 'HUGGIES NATURAL CARE SENSITIVE SKIN BABY WIPES 200 COUNT OR LARGER';
UPDATE receipts SET brandCode = 'CRYSTAL LIGHT' WHERE rewardsGroup = 'CRYSTAL LIGHT LIQUID DRINK MIX';