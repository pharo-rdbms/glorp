tests
testLoneBase
	original := BaseExpression new.
	rebuilt := original rebuildOn: newBase.
	self assert: rebuilt == newBase.