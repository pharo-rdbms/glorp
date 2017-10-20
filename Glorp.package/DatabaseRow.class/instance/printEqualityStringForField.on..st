printing
printEqualityStringForField: aDatabaseField on: aCommand 
	"Get around PostgreSQL bug.  Qualified names cannot appear in SET expression."
	aCommand nextPutAll: (aDatabaseField platform nameForColumn: aDatabaseField name).
	aCommand nextPutAll: ' = '.
	self printValueOfField: aDatabaseField on: aCommand