querying
removeClass: aClass key: aKey ifAbsent: failBlock 
	| cache |
	cache := self cacheForClass: aClass.
	(cache includesKey: aKey withClass: aClass) ifFalse: [^failBlock value].
	cache removeKey: aKey ifAbsent: [ failBlock value ].