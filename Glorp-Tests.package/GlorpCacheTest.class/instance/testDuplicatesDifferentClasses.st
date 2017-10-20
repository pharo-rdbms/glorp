tests
testDuplicatesDifferentClasses

	| cust trans |
	cust := GlorpCustomer example1.
	trans := GlorpBankTransaction example1.
	cache at: 3 insert: cust.
	cache at: 3 insert: trans.
	self assert: (cache lookupClass: GlorpCustomer key: 3) = cust.
	self assert: (cache lookupClass: GlorpBankTransaction key: 3) = trans.