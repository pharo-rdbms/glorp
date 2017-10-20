printing
printLockEqualityForField: aDatabaseField on: aStream
	| expression |
	expression := ((BaseExpression new getTable: aDatabaseField table) getField: aDatabaseField) get: #= withArguments: (Array with: (oldVersion at: aDatabaseField)).
	expression printSQLOn: aStream withParameters: #().