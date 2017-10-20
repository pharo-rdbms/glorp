tests
testUpdateWithExpiredExistingEntry2
	self helpTestUpdateWithExpiredExistingEntry: (TimedStrongCachePolicy new timeout: 0; expiryAction: #refresh).