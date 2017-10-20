tests-ordering
testSingleOrderingAddress2

	self 
		helpTestSingleOrderingBy: [:each | each number]
		setup: [self writeAddressOrderingRows].