tests-outer scope references
testRebuildMappingWithStart

	original := [:each | each foo bar] asGlorpExpression.
	rebuilt := original rebuildOn: newBase startingFrom: original base.
	self assert: rebuilt base == newBase.