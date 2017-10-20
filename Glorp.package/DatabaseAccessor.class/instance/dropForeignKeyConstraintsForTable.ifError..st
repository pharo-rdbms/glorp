executing
dropForeignKeyConstraintsForTable: aTable ifError: aBlock 
	aTable isImaginary ifTrue: [^self].
	aTable  foreignKeyConstraints do: [:each | self dropConstraint: each ifError: [ :ex | aBlock value: ex]].