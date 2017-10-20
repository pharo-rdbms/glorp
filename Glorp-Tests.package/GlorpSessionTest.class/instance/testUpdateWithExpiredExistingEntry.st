tests
testUpdateWithExpiredExistingEntry
	self helpTestUpdateWithExpiredExistingEntry: (TimedExpiryCachePolicy new timeout: 0; expiryAction: #refresh).