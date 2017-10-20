accessing
proxyInitialize
	super proxyInitialize.
	secondsToLive := 30.
	self updateExpiryTime.