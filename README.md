# Change managment log
This is a project for managing changes made on business applications. Below is a draft of the database to be used for the logging purpose.

### Change management flow
**Change** => **Problem** => **Change Request** => **Change Plan** => **Approved Change** => **Applied Change**

To enforce this flow, a foreign key constraint is applied to each table in the flow in a way that the primary key of a table references the primary key of the table preceding it in the flow as a foreign key.
E.g.: Problem(ChangeID) references Change(ChangeID)

The ChangeHistory table is an exception since it is not part of the change management flow. It references Change(ChangeID) to avoid creation of change history for unknown change.

**Database Name**: AutolineChangelog
**Tables**:
1. Change
	ChangeID INTEGER PRIMARY KEY
	HelpDeskRequestID INTEGER
	ChangeStatus TEXT

2. Problem
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES Change(ChangeID)
	Description TEXT
	IdentifiedDate DATE
	IdentifiedBy TEXT

3. ChangeRequest
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES Problem(ChangeID)
	Description TEXT
	RequestedDate DATE
	RequestedBY TEXT
	ApprovedBY TEXT
	ApprovedDate DATE
	Department TEXT
	AffectedModules TEXT
	AffectedDepartments TEXT

4. ChangePlan
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES ChangeRequest(ChangeID)
	Description TEXT
	PlannedDate DATE
	PlannedBY TEXT
	TargetSoftware TEXT
	TargetModule TEXT
	AffectedModules TEXT
	AffectedDepartments TEXT

5. ApprovedChange
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES ChangePlan(ChangeID)
	Description TEXT
	ApprovedBY TEXT
	ApprovedDate DATE

6. AppliedChange
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES ApprovedChange(ChangeID)
	Description TEXT
	AppliedBY TEXT
	AppliedDate DATE

7. ChangeHistory
	ChangeID INTEGER PRIMARY KEY FOREIGN KEY REFERENCES Change(ChangeID)
	IncidentReportDate DATE
	ProblemIdentifiedDate DATE
	ChangeRequestedDate DATE
	ChangePlannedDate DATE
	ChangeApprovedDate DATE
	ChangeAppliedDate DATE
