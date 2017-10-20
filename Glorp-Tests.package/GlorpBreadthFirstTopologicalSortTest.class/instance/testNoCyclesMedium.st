tests
testNoCyclesMedium
	self sort: self dataForNoCyclesMedium.
	self assertSortOrder: #('c1' 'c2' 'c3' 'c4' 'b1' 'b2' 'b3' 'b4' 'a1' 'a2' 'a3' 'a4').