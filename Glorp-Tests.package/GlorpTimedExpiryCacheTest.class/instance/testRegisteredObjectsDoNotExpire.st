tests
testRegisteredObjectsDoNotExpire
	| customer |
	self setUpExpiryWithZeroDelay.
	self setUpForNotifyAndRemove.
	customer := GlorpCustomer example1.
	customer id: 3.
	cache at: 3 insert: customer.
	session beginUnitOfWork.
	session register: customer.
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == customer.
	self deny: customer seenExpiry.