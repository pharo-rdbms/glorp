tests
setUpExpiryWithZeroDelay
	(cache session descriptorFor: GlorpCustomer) cachePolicy: (TimedStrongCachePolicy new timeout: 0).
	(cache session descriptorFor: GlorpBankTransaction) cachePolicy: (TimedStrongCachePolicy new timeout: 0).