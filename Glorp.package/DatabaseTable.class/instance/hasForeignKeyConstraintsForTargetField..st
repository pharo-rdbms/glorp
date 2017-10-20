constraints
hasForeignKeyConstraintsForTargetField: aField
	^self foreignKeyConstraints anySatisfy: [:each | each targetFields includes: aField].