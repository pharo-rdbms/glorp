testing
hasForeignKeyConstraintMatching: aConstraint
	^self foreignKeyConstraints
		anySatisfy: [:each | (each matchesForeignKeyConstraint: aConstraint)].