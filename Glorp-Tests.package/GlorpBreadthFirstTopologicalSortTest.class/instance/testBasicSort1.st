tests
testBasicSort1
	self sort: self data1.
	self assertSortOrder: #(3 2 1).