printing
printForConstraintName: aField on: aStream maxLength: maxLength 
	| constraintName |
	constraintName := aField table name , '_' , aField name.
	constraintName size > maxLength 
		ifTrue: [constraintName := constraintName copyFrom: 1 to: maxLength].
	aStream nextPutAll: constraintName