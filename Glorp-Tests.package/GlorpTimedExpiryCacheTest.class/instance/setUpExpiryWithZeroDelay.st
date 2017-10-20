support
setUpExpiryWithZeroDelay
	(cache session descriptorFor: GlorpCustomer) cachePolicy: (TimedExpiryCachePolicy new timeout: 0).
	(cache session descriptorFor: GlorpBankTransaction) cachePolicy: (TimedExpiryCachePolicy new timeout: 0).