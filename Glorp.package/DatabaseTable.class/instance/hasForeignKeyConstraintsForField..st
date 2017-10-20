constraints
hasForeignKeyConstraintsForField: aField
	^self foreignKeyConstraints anySatisfy: [:each | each sourceFields includes: aField].