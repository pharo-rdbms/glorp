executing
dropTable: aTable ifError: aBlock 
	aTable isImaginary ifTrue: [^self].
	self dropForeignKeyConstraintsForTable: aTable ifError: aBlock.
	self dropTableDefinition: aTable ifError: aBlock.