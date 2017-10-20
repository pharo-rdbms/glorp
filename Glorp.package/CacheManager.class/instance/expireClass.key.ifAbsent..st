querying
expireClass: aClass key: aKey ifAbsent: failBlock 
	| cache |
	cache := self cacheForClass: aClass.
	(cache includesKey: aKey withClass: aClass) ifFalse: [^failBlock value].
	cache expireKey: aKey ifAbsent: [ failBlock value ].