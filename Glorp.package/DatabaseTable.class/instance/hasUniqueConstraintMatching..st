testing
hasUniqueConstraintMatching: aConstraint
	
	^self uniqueConstraints anySatisfy: [:each | each matchesUniqueConstraint: aConstraint]