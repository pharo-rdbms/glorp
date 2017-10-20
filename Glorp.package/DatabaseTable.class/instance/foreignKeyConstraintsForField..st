constraints
foreignKeyConstraintsForField: aField
	^self foreignKeyConstraints select: [:each | each sourceFields includes: aField].