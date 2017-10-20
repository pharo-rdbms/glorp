tests-refreshing
testExpiryTimeReset
	| cachePolicy |
	cachePolicy := TimedExpiryCachePolicy new.
	cachePolicy timeoutSeconds: 4.
	cachePolicy expiryAction: #remove.
	(session descriptorFor: GlorpAddress) cachePolicy: cachePolicy.
	self checkExpiryTime: [:expiryTime :newExpiryTime :address | 
		self assert: newExpiryTime > expiryTime.
		self assert: address street = 'Paseo Montril'].