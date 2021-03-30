-- Create Tables
CREATE TABLE Change (
	ChangeID INT IDENTITY(1,1) PRIMARY KEY,
	HelpDeskRequestID INT,
	ChangeStatus VARCHAR(max) DEFAULT 'Change logged',
	Remark VARCHAR(max),
	Environment VARCHAR(100),
	ChangeType VARCHAR(100),
	CONSTRAINT check_changetype CHECK (ChangeType IN ('Emergency', 'Pre Approved', 'Standard')),
	CONSTRAINT check_changestatus CHECK (ChangeStatus IN ('Change logged', 'Problem Identified', 'Change Requested',
													  'Change Planned', 'Change Approved', 'Change Applied'))
	)

CREATE TABLE Problem (
	ChangeID INT PRIMARY KEY FOREIGN KEY REFERENCES Change(ChangeID),
	Description VARCHAR(max),
	IdentifiedDate DATE,
	IdentifiedBy VARCHAR(100),
	Remark VARCHAR(max)
	)

CREATE TABLE ChangeRequest (
	ChangeID INT PRIMARY KEY FOREIGN KEY REFERENCES Problem(ChangeID),
	Description VARCHAR(max),
	RequestedDate DATE,
	RequestedBY VARCHAR(100),
	ApprovedBY VARCHAR(100),
	ApprovedDate DATE,
	Department VARCHAR(100),
	AffectedModules VARCHAR(100),
	AffectedDepartments VARCHAR(100),
	Remark VARCHAR(max)
	)
	
CREATE TABLE ChangePlan (
	ChangeID INT PRIMARY KEY FOREIGN KEY REFERENCES ChangeRequest(ChangeID),
	Description VARCHAR(max),
	PlannedDate DATE,
	PlannedBY VARCHAR(100),
	TargetSoftware VARCHAR(100),
	TargetModule VARCHAR(100),
	AffectedModules VARCHAR(100),
	AffectedDepartments VARCHAR(100),
	Remark VARCHAR(max)
	)

CREATE TABLE ApprovedChange (
	ChangeID INT PRIMARY KEY FOREIGN KEY REFERENCES ChangePlan(ChangeID),
	Description VARCHAR(max),
	ApprovedBY VARCHAR(100),
	ApprovedDate DATE,
	Remark VARCHAR(max)
	)

CREATE TABLE AppliedChange (
	ChangeID INT PRIMARY KEY FOREIGN KEY REFERENCES ApprovedChange(ChangeID),
	Description VARCHAR(max),
	AppliedBY VARCHAR(100),
	AppliedDate DATE,
	Remark VARCHAR(max)
	)

CREATE TABLE ChangeHistory (
	ChangeID INT PRIMARY KEY FOREIGN KEY REFERENCES Change(ChangeID),
	IncidentReportDate DATE,
	ProblemIdentifiedDate DATE,
	ChangeRequestedDate DATE,
	ChangePlannedDate DATE,
	ChangeApprovedDate DATE,
	ChangeAppliedDate DATE,
	Remark VARCHAR(max)
	)

CREATE TABLE Reference (
	ChangeID INT FOREIGN KEY REFERENCES Change(ChangeID),
	RefType VARCHAR(100),
	RefID VARCHAR(100),
	PRIMARY KEY (ChangeID, RefType, RefID),
	Remark VARCHAR(max)
	)

-- Update history on Change logged
CREATE TRIGGER UPDATE_ChangeHistory ON Change
FOR INSERT 
NOT FOR REPLICATION 
AS
 
BEGIN
  INSERT INTO ChangeHistory 
	(ChangeID, IncidentReportDate)
	SELECT ChangeID, getdate()
	FROM inserted
END
-- end of trigger

-- update change log history and status at every stage of the change flow

-- trigger on Problem Identification stage
CREATE TRIGGER UPDATE_Status_N_History_ON_Problem ON Problem
FOR INSERT 
NOT FOR REPLICATION 
AS
 
BEGIN
  UPDATE ChangeHistory 
	SET	ProblemIdentifiedDate = (SELECT IdentifiedDate FROM INSERTED)
	WHERE ChangeHistory.ChangeID = (SELECT ChangeID FROM INSERTED)

  UPDATE Change
	SET ChangeStatus='Problem Identified'
	WHERE Change.ChangeID = (SELECT ChangeID FROM INSERTED)
END
-- end of trigger

-- trigger on Change Requested stage
CREATE TRIGGER UPDATE_Status_N_History_ON_ChangeRequest ON ChangeRequest
FOR INSERT 
NOT FOR REPLICATION 
AS
 
BEGIN
  UPDATE ChangeHistory 
	SET	ChangeRequestedDate = (SELECT RequestedDate FROM INSERTED)
	WHERE ChangeHistory.ChangeID = (SELECT ChangeID FROM INSERTED)

  UPDATE Change
	SET ChangeStatus='Change Requested'
	WHERE Change.ChangeID = (SELECT ChangeID FROM INSERTED)
END
-- end of trigger

-- trigger on Change Planned stage
CREATE TRIGGER UPDATE_Status_N_History_ON_ChangePlan ON ChangePlan
FOR INSERT 
NOT FOR REPLICATION 
AS
 
BEGIN
  UPDATE ChangeHistory 
	SET	ChangePlannedDate = (SELECT PlannedDate FROM INSERTED)
	WHERE ChangeHistory.ChangeID = (SELECT ChangeID FROM INSERTED)

  UPDATE Change
	SET ChangeStatus='Change Planned'
	WHERE Change.ChangeID = (SELECT ChangeID FROM INSERTED)
END
-- end of trigger

-- trigger on Approved Change stage
CREATE TRIGGER UPDATE_Status_N_History_ON_ApprovedChange ON ApprovedChange
FOR INSERT 
NOT FOR REPLICATION 
AS
 
BEGIN
  UPDATE ChangeHistory 
	SET	ChangeApprovedDate = (SELECT ApprovedDate FROM INSERTED)
	WHERE ChangeHistory.ChangeID = (SELECT ChangeID FROM INSERTED)

  UPDATE Change
	SET ChangeStatus='Change Approved'
	WHERE Change.ChangeID = (SELECT ChangeID FROM INSERTED)
END
-- end of trigger

-- trigger on Applied Change stage
CREATE TRIGGER UPDATE_Status_N_History_ON_AppliedChange ON AppliedChange
FOR INSERT 
NOT FOR REPLICATION 
AS
 
BEGIN
  UPDATE ChangeHistory 
	SET	ChangeAppliedDate = (SELECT AppliedDate FROM INSERTED)
	WHERE ChangeHistory.ChangeID = (SELECT ChangeID FROM INSERTED)

  UPDATE Change
	SET ChangeStatus='Change Applied'
	WHERE Change.ChangeID = (SELECT ChangeID FROM INSERTED)
END
-- end of trigger

-- test query
INSERT INTO Change
	(HelpDeskRequestID, Environment, ChangeType)
	VALUES (16756, 'Live', 'Pre Approved')

INSERT INTO Problem
	(ChangeID, Description, IdentifiedDate, IdentifiedBy, Remark)
	VALUES (1, 'Dumy problem',getdate() , 'Kirubel', 'This just fo testing purpose')

INSERT INTO ChangeRequest
	(ChangeID, Description, RequestedDate, RequestedBy, Remark)
	VALUES (1, 'Dumy change Request', getdate() , 'Kirubel', 'This is a change request for testing purpose')

INSERT INTO ChangePlan
	(ChangeID, Description, PlannedDate, PlannedBy, Remark)
	VALUES (1, 'Dumy change plan', getdate() , 'Kirubel', 'This is a change plan for testing purpose')

INSERT INTO ApprovedChange
	(ChangeID, Description, ApprovedDate, ApprovedBy, Remark)
	VALUES (1, 'Dumy change approval', getdate() , 'Kirubel', 'This is a change approval for testing purpose')

INSERT INTO AppliedChange
	(ChangeID, Description, AppliedDate, AppliedBy, Remark)
	VALUES (1, 'Dumy change applied', getdate() , 'Kirubel', 'This is a change application for testing purpose')

SELECT * FROM Change

SELECT * FROM ChangeHistory