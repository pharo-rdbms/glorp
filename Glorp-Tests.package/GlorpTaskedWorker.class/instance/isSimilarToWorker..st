accessing
isSimilarToWorker: aWorker
	"Compare values, ignoring #ids, which are assigned by the database."

	| myKeys otherKeys myTask otherTask |
	myKeys := self tasks keys asSortedCollection.
	otherKeys := aWorker tasks keys asSortedCollection.
	myKeys = otherKeys ifFalse: [^false].
	myKeys do: [:aKey|
		myTask := self tasks at: aKey.
		otherTask := aWorker tasks at: aKey.
		myTask description = otherTask description ifFalse: [^false]].
	^true