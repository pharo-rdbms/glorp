tests-refreshing
testExpiryTimeNotReset
	| cachePolicy |
	cachePolicy := TimedExpiryCachePolicy new.
	cachePolicy timeoutSeconds: 3.
	cachePolicy expiryAction: #refresh.
	(session descriptorFor: GlorpAddress) cachePolicy: cachePolicy.
	self checkExpiryTime: [:expiryTime :newExpiryTime :address | 
		self assert: newExpiryTime = expiryTime.
		self assert: address street = 'Paseo Montril'].