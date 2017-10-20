tests
testDuplicates 
	| c1 c2 |
	c1 := GlorpCustomer example1.
	c2 := GlorpCustomer example1.
	cache at: 3 insert: c1.
	cache at: 3 insert: c2.
	self assert: (cache lookupClass: GlorpCustomer key: 3) = c1.