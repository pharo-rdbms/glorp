tests
validateFor: aCollection against: expectedArrayContents
	^(aCollection collect: [:each | each name]) asSortedCollection asArray
		= expectedArrayContents.