USE [scratchpad];

DROP DATABASE IF EXISTS fetchdanalyst;
CREATE DATABASE fetchdanalyst;

USE [fetchdanalyst];

CREATE TABLE brands (
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

CREATE TABLE receipts (
	row_n INT IDENTITY(1,1) PRIMARY KEY,
	oid NVARCHAR(MAX),
	bonusPointsEarned INT,
	bonusPointsEarnedReason VARCHAR(128),
	createDateUnix NVARCHAR(MAX),
	dateScannedUnix NVARCHAR(MAX),
	finishedDateUnix NVARCHAR(MAX),
	modifyDateUnix NVARCHAR(MAX),
	pointsAwardedDateUnix NVARCHAR(MAX),
	totalPointsEarned FLOAT,
	purchaseDateUnix NVARCHAR(MAX),
	purchasedItemCount INT,
	item NVARCHAR(MAX),
	barcode NVARCHAR(MAX),
	brandCode NVARCHAR(MAX),
	competitorRewardsGroup NVARCHAR(MAX),
	[description] NVARCHAR(MAX),
	discountedItemPrice NVARCHAR(MAX),
	finalPrice NVARCHAR(MAX),
	itemPrice NVARCHAR(MAX),
	metabriteCampaignId NVARCHAR(MAX),
	needsFetchReview NVARCHAR(MAX),
	originalReceiptItemText NVARCHAR(MAX),
	partnerItemId NVARCHAR(MAX),
	pointsEarned NVARCHAR(MAX),
	pointsNotAwardedReason NVARCHAR(MAX),
	pointsPayerId NVARCHAR(MAX),
	preventTargetGapPoints NVARCHAR(MAX),
	quantityPurchased NVARCHAR(MAX),
	rewardsGroup NVARCHAR(MAX),
	rewardsProductPartnerId NVARCHAR(MAX),
	userFlaggedBarcode NVARCHAR(MAX),
	userFlaggedNewItem NVARCHAR(MAX),
	userFlaggedPrice NVARCHAR(MAX),
	userFlaggedQuantity NVARCHAR(MAX),
	rewardsReceiptStatus VARCHAR(8),
	totalSpent FLOAT,
	userId VARCHAR(24)
);

CREATE TABLE users (
	oid NVARCHAR(MAX) NOT NULL,
	active BIT,
	createdDateUnix NVARCHAR(MAX),
	lastLoginUnix NVARCHAR(MAX),
	[role] VARCHAR(11),
	signUpSource VARCHAR(6),
	[state] VARCHAR(2)
);