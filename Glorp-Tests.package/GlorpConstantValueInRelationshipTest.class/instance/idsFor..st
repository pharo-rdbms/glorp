support
idsFor: aCollection

	^(aCollection collect: [:each | each id]) asSortedCollection asArray.