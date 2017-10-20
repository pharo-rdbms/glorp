tests
testMedium1
	self sort: self dataForMedium.
	self assertSortOrder: #('c1' 'a2' 'b1' 'a1' 'c3' 'a4' 'b3' 'a3' 'b2' 'b4' 'c2' 'c4').