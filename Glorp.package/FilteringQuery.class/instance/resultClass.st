accessing
resultClass
	collection class == GlorpVirtualCollection ifTrue: [^collection getQuery resultClass].
	^(collection detect: [:each | true] ifNone: [nil]) class