tests-refreshing
testSessionRefreshOnExpiryWithCacheLookupOnly
	"Check that we refresh correctly when an object has expired, doing only a cache lookup, not an explicit read"
	| cachePolicy |
	cachePolicy := TimedExpiryCachePolicy new.
	cachePolicy timeout: 0.
	cachePolicy expiryAction: #refresh.
	(session descriptorFor: GlorpAddress) cachePolicy: cachePolicy.
	self checkRefreshDoing: [:anAddress |
		session privateGetCache lookupClass: GlorpAddress key: 123 ifAbsent: [nil]].