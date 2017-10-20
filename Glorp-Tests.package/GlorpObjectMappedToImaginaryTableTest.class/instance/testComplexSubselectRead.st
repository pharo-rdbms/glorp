tests
testComplexSubselectRead
	"This exercises doubly-nested subselects, which caused a problem in a user application with joining to the wrong table"

	| |
	self assert: (session execute: (self queryForComplexSubselectRead: 3)) size = 1.
	self assert: (session execute: (self queryForComplexSubselectRead: 4)) size = 0.