querying
lookupClass: aClass key: aKey ifAbsent: failBlock

	| object |
	object := (self cacheForClass: aClass) at: aKey ifAbsent: failBlock.
	^(object isKindOf: aClass)
		ifTrue: [ object ]
		ifFalse: [ failBlock value ].