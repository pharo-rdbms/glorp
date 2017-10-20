support
setUpExpiryWithRealDelay
	(cache session descriptorFor: GlorpCustomer) cachePolicy: (TimedExpiryCachePolicy new timeout: 1).
	(cache session descriptorFor: GlorpBankTransaction) cachePolicy: (TimedExpiryCachePolicy new timeout: 1).