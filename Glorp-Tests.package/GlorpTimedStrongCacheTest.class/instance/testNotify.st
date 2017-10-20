tests
testNotify
	| customer |
	self setUpExpiryWithZeroDelay.
	self setUpForNotify.
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self deny: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	self assert: customer seenExpiry.