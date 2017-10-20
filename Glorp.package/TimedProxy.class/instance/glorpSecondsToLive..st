accessing
glorpSecondsToLive: seconds

	secondsToLive := seconds.
	self updateExpiryTime.
	reaper notNil ifTrue: [self glorpTouch]