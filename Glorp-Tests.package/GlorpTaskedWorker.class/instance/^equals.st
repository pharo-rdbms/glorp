comparing
= aWorker
	super = aWorker ifFalse: [^false].
	(tasks keys asSortedCollection = aWorker tasks keys asSortedCollection) ifFalse: [^false].
	(tasks asSortedCollection = aWorker tasks asSortedCollection) ifFalse: [^false].
	^true