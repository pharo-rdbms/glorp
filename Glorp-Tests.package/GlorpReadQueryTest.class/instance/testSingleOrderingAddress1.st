tests-ordering
testSingleOrderingAddress1

	self 
		helpTestSingleOrderingBy: [:each | each street]
		setup: [self writeAddressOrderingRows].