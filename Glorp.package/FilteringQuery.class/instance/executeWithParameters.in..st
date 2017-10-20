executing
executeWithParameters: parameterArray in: aSession
	| filtered result |
	session := aSession.
	collection class == GlorpVirtualCollection
		ifTrue:
			[collection setSession: aSession.
			collection parameters: parameterArray.
			collection := collection realObjects].
	filtered := self filterResultsForParameters: parameterArray.
	result := self transformsValues
		ifTrue: [filtered collect: [:each | self valueFor: each]]
		ifFalse: [filtered].
	result := (self collectionTypesAgree: result) ifTrue: [result] ifFalse: [self resultCollectionFor: result readStream].
	^self readsOneObject
		ifTrue: [result detect: [:each | true] ifNone: [nil]]
		ifFalse: [result]