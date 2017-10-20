accessing
addToReaper: aProxy

	aProxy class == TimedProxy ifFalse: [^self].
	self reaper add: aProxy