-- Create Tables
CREATE TABLE Change (
	ChangeID INTEGER PRIMARY KEY,
	HelpDeskRequestID INTEGER,
	ChangeStatus VARCHAR,
	Remark VARCHAR,
	Environment VARCHAR(100),
	ChangeType VARCHAR(50),
	CONSTRAINT check_changetype CHECK (ChangeType IN ('Emergency', 'Pre Approved', 'Standard'))
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

CREATE TABLE Reference (
	ChangeID INTEGER FOREIGN KEY REFERENCES Change(ChangeID),
	RefType VARCHAR(100),
	RefID VARCHAR(100),
	PRIMARY KEY (ChangeID, RefType, RefID),
	Remark VARCHAR
	)
