accessing
glorpTouch
	self updateExpiryTime.
	reaper isNil ifFalse: [reaper touch: self].