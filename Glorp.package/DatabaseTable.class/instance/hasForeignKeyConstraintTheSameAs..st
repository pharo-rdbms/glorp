testing
hasForeignKeyConstraintTheSameAs: aConstraint

	^self foreignKeyConstraints anySatisfy: [:each | (each isTheSameAs: aConstraint)].