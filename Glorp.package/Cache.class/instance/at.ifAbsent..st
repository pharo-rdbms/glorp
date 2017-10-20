lookup
at: key ifAbsent: aBlock 
	| item value |
	item := self basicAt: key ifAbsent: [^aBlock value].
	value := policy contentsOf: item.
	(self hasItemExpired: item) 
		ifTrue: 
			[policy takeExpiryActionForKey: key withValue: value in: self. 
			(items includesKey: key) ifFalse: [^aBlock value]].
	^value.