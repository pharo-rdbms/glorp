accessing
reaper

	reaper isNil ifTrue: [self initializeReaper].
	^reaper.