executing
valueFor: anObject
	collectBlock isNil ifTrue: [^anObject].
	^collectBlock value: anObject