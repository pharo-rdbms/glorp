private
realObjects
	realObjects isNil ifTrue: [	realObjects := query executeWithParameters: parameters in: session].
	^realObjects.