printing
printEqualityTemplateForField: aDatabaseField on: aCommand
	"Get around PostgreSQL bug.  Qualified names cannot appear in SET expression."
	| bind |
	aCommand nextPutAll: (aDatabaseField platform nameForColumn: aDatabaseField name).
	aCommand nextPutAll: ' = '.
	bind := aCommand canBind: (self at: aDatabaseField ifAbsent: [nil]) to: aDatabaseField type.
	bind
		ifTrue: [aCommand nextPutAll: '?']
		ifFalse: [self printValueOfField: aDatabaseField on: aCommand].