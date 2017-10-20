tests
testMapping
	original := [:each | each foo] asGlorpExpression.
	rebuilt := original rebuildOn: newBase.
	self assert: rebuilt base == newBase.