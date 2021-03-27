-- Create Tables
CREATE TABLE Change (
	ChangeID INTEGER PRIMARY KEY,
	HelpDeskRequestID INTEGER,
	ChangeStatus TEXT
	)

CREATE TABLE Problem (
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES Change(ChangeID),
	Description TEXT,
	IdentifiedDate DATE,
	IdentifiedBy TEXT
	)

CREATE TABLE ChangeRequest (
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES Problem(ChangeID),
	Description TEXT,
	RequestedDate DATE,
	RequestedBY TEXT,
	ApprovedBY TEXT,
	ApprovedDate DATE,
	Department TEXT,
	AffectedModules TEXT,
	AffectedDepartments TEXT
	)
	
CREATE TABLE ChangePlan (
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES ChangeRequest(ChangeID),
	Description TEXT,
	PlannedDate DATE,
	PlannedBY TEXT,
	TargetSoftware TEXT,
	TargetModule TEXT,
	AffectedModules TEXT,
	AffectedDepartments TEXT
	)

CREATE TABLE ApprovedChange (
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES ChangePlan(ChangeID),
	Description TEXT,
	ApprovedBY TEXT,
	ApprovedDate DATE
	)

CREATE TABLE AppliedChange (
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES ApprovedChange(ChangeID),
	Description TEXT,
	AppliedBY TEXT,
	AppliedDate DATE
	)

CREATE TABLE ChangeHistory (
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES Change(ChangeID),
	IncidentReportDate DATE,
	ProblemIdentifiedDate DATE,
	ChangeRequestedDate DATE,
	ChangePlannedDate DATE,
	ChangeApprovedDate DATE,
	ChangeAppliedDate DATE
	)

/* ANOTHER WAY TO APPLY FOREIGN KEY */
--ALTER TABLE AppliedChange
--	ADD CONSTRAINT FK__ChangeID
--	FOREIGN KEY (ChangeID) REFERENCES Change(ChangeID)

/* GET THE CONSTRAINT NAME APPLIED ON A TABLE */
--SELECT CONSTRAINT_NAME, TABLE_SCHEMA , TABLE_NAME, CONSTRAINT_TYPE
--	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
--	WHERE TABLE_NAME='AppliedChange'