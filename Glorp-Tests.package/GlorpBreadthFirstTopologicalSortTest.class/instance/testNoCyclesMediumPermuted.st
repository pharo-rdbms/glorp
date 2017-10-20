tests
testNoCyclesMediumPermuted
	self sort: self dataForNoCyclesMediumPermuted.
	self assertSortOrder: #('c1' 'b1' 'c2' 'b2' 'c3' 'b3' 'c4' 'b4' 'a1' 'a2' 'a3' 'a4').