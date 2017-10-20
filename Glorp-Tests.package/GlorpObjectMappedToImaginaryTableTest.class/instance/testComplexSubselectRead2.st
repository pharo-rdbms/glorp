tests
testComplexSubselectRead2
	"This exercises doubly-nested subselects, which caused a problem in a user application with joining to the wrong table"

	| |
	self assert: (session execute: (self queryForComplexSubselectRead2: 1)) size = 1.
	self assert: (session execute: (self queryForComplexSubselectRead2: 0)) size = 2.