building objects
nextAnswerFromUnderlyingCursor
	| objects |
	rawPeekBuffer isNil ifTrue: [rawPeekBuffer := cursor next].
	rawPeekBuffer isNil ifTrue: [^nil].
	objects := self buildObjectsForRow: rawPeekBuffer.
	rawPeekBuffer := nil.
	^objects.