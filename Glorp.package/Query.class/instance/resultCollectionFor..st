executing
resultCollectionFor: aCursoredStream
	| results finalAnswer |
	collectionType isNil ifTrue: [^aCursoredStream upToEnd].
	collectionType == aCursoredStream class ifTrue: [^aCursoredStream].
	results := (aCursoredStream newCollectionOfSize: self expectedRows for: collectionType) writeStream.
	results nextPutAll: aCursoredStream upToEnd.
	finalAnswer := results contents.
	session register: finalAnswer.
	^finalAnswer