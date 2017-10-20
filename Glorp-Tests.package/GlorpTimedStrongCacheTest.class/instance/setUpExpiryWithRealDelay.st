tests
setUpExpiryWithRealDelay
	(cache session descriptorFor: GlorpCustomer) cachePolicy: (TimedStrongCachePolicy new timeout: 1).
	(cache session descriptorFor: GlorpBankTransaction) cachePolicy: (TimedStrongCachePolicy new timeout: 1).