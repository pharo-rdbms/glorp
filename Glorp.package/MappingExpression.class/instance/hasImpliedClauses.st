testing
hasImpliedClauses
	^self mapping notNil and: [self mapping hasImpliedClauses].