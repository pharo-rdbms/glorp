caching
includes: aTimedProxy

	self at: aTimedProxy glorpId ifAbsent: [^false].
	^true