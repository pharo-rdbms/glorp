printing
printEqualityTemplateForField: aDatabaseField on: aCommand withBinding: aBoolean
	"Get around PostgreSQL bug.  Qualified names cannot appear in SET expression."
	aCommand nextPutAll: (aDatabaseField platform nameForColumn: aDatabaseField name).
	aCommand nextPutAll: ' = '.
	aBoolean 
		ifTrue: [aCommand nextPutAll: '?']
		ifFalse: [self printValueOfField: aDatabaseField on: aCommand].