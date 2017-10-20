printing
printForConstraintNames: aCollection on: aStream maxLength: maxLength 
	| constraintName |
	constraintName := self table name.
	aCollection do:
		[:each | constraintName := constraintName, each name].
	constraintName size > maxLength 
		ifTrue: [constraintName := constraintName copyFrom: 1 to: maxLength].
	aStream nextPutAll: constraintName