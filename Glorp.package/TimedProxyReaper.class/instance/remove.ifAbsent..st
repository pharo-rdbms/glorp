caching
remove: aTimedProxy ifAbsent: errorBlock

	^self removeKey: aTimedProxy glorpId ifAbsent: errorBlock.