tests
testNotifyAndRemove
	| customer |
	self setUpExpiryWithZeroDelay.
	self setUpForNotifyAndRemove.
	customer := GlorpCustomer example1.
	cache at: 3 insert: customer.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == nil.
	self assert: customer seenExpiry = true.