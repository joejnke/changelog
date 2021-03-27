-- Create Tables
CREATE TABLE Change (
	ChangeID INTEGER PRIMARY KEY,
	HelpDeskRequestID INTEGER,
	ChangeStatus VARCHAR,
	Remark VARCHAR
	)

CREATE TABLE Problem (
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES Change(ChangeID),
	Description VARCHAR,
	IdentifiedDate DATE,
	IdentifiedBy VARCHAR(100),
	Remark VARCHAR
	)

CREATE TABLE ChangeRequest (
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES Problem(ChangeID),
	Description VARCHAR,
	RequestedDate DATE,
	RequestedBY VARCHAR(100),
	ApprovedBY VARCHAR(100),
	ApprovedDate DATE,
	Department VARCHAR(100),
	AffectedModules VARCHAR(100),
	AffectedDepartments VARCHAR(100),
	Remark VARCHAR
	)
	
CREATE TABLE ChangePlan (
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES ChangeRequest(ChangeID),
	Description VARCHAR,
	PlannedDate DATE,
	PlannedBY VARCHAR(100),
	TargetSoftware VARCHAR(100),
	TargetModule VARCHAR(100),
	AffectedModules VARCHAR(100),
	AffectedDepartments VARCHAR(100),
	Remark VARCHAR
	)

CREATE TABLE ApprovedChange (
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES ChangePlan(ChangeID),
	Description VARCHAR,
	ApprovedBY VARCHAR(100),
	ApprovedDate VARCHAR(100),
	Remark VARCHAR
	)

CREATE TABLE AppliedChange (
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES ApprovedChange(ChangeID),
	Description VARCHAR,
	AppliedBY VARCHAR(100),
	AppliedDate DATE,
	Remark VARCHAR
	)

CREATE TABLE ChangeHistory (
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES Change(ChangeID),
	IncidentReportDate DATE,
	ProblemIdentifiedDate DATE,
	ChangeRequestedDate DATE,
	ChangePlannedDate DATE,
	ChangeApprovedDate DATE,
	ChangeAppliedDate DATE,
	Remark VARCHAR
	)

/* ANOTHER WAY TO APPLY FOREIGN KEY */
--ALTER TABLE AppliedChange
--	ADD CONSTRAINT FK__ChangeID
--	FOREIGN KEY (ChangeID) REFERENCES Change(ChangeID)

/* GET THE CONSTRAINT NAME APPLIED ON A TABLE */
--SELECT CONSTRAINT_NAME, TABLE_SCHEMA , TABLE_NAME, CONSTRAINT_TYPE
--	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
--	WHERE TABLE_NAME='AppliedChange'