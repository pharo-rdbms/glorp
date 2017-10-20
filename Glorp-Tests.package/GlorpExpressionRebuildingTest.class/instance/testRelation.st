tests
testRelation
	original := [:each | each foo bar = each foo bletch] asGlorpExpression.
	rebuilt := original rebuildOn: newBase.
	self assert: rebuilt ultimateBaseExpression == newBase.
	self assert: rebuilt leftChild ultimateBaseExpression == newBase.
	self assert: rebuilt rightChild ultimateBaseExpression == newBase.
	self assert: rebuilt leftChild base base == newBase.