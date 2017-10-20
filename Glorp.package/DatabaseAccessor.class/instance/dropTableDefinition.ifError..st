executing
dropTableDefinition: aTable ifError: aBlock
	"The dropping of the primary key constraints (a singular object not a collection, despite its name) is probably not needed before dropping the table by any database platform.  If 'platform supportsConstraints' is false then it will not be done, since dropConstraint:ifError: assumes it is called on a foreign key constraint (the case in all other callers) and does nothing if the platform does not support them."

	aTable isImaginary ifTrue: [^self].
	aTable hasPrimaryKeyConstraints ifTrue: [self dropConstraint: aTable  primaryKeyConstraints ifError: [:ex | aBlock value: ex]].
	self dropTableNamed: aTable qualifiedName ifAbsent: aBlock.