tests
testHasExpired1
	| customer |
	customer := self addCustomerToCache.
	self deny: (session hasExpired: customer)