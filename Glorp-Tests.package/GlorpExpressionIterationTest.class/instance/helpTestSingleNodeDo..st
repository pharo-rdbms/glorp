tests
helpTestSingleNodeDo: exp 
	self assert: (exp collect: [:each | each]) = (OrderedCollection with: exp)