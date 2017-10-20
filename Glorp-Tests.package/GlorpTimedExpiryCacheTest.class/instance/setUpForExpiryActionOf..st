support
setUpForExpiryActionOf: aSymbol
	(cache session descriptorFor: GlorpCustomer) cachePolicy expiryAction: aSymbol.
	(cache session descriptorFor: GlorpBankTransaction) cachePolicy expiryAction: aSymbol.