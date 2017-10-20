services columns
printColumn: eachGlorpDatabaseField on: sqlStatementStream
	"Print the column specification for the CREATE TABLE statement.
	Don't show a default value for serial columns, since their semanitics are different."

	sqlStatementStream
		nextPutAll: (self nameForColumn: eachGlorpDatabaseField name);
		space;
		nextPutAll: eachGlorpDatabaseField typeString;
		space;
		nextPutAll: 
				(eachGlorpDatabaseField type isSerial
					ifTrue: ['']
					ifFalse: [self sqlTextForDEFAULT: eachGlorpDatabaseField defaultValue]);
		space;
		nextPutAll:
				(eachGlorpDatabaseField isNullable
						ifTrue: [self sqlTextForNULLAttributeConstraint]
						ifFalse: [self sqlTextForNOTNULLAttributeConstraint]);
		space;
		nextPutAll:
				(eachGlorpDatabaseField isUnique
						ifTrue: [self sqlTextForUNIQUEAttributeConstraint]
						ifFalse: [self sqlTextForNOTUNIQUEAttributeConstraint]).