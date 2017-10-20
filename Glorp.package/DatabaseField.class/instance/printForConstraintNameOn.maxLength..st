obsolete
printForConstraintNameOn: aStream maxLength: maxLength 
	| constraintName |
	constraintName := table name , '_' , name.
	constraintName size > maxLength 
		ifTrue: [constraintName := constraintName copyFrom: 1 to: maxLength].
	aStream nextPutAll: constraintName