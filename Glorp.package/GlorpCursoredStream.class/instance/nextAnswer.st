building objects
nextAnswer
	| result |
	peekBuffer isNil ifFalse: [
		result := peekBuffer.
		peekBuffer := nil.
		^result].
	^self nextAnswerFromUnderlyingCursor.