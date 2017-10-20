accessing
peek
	peekBuffer = nil ifFalse: [^peekBuffer].
	peekBuffer := self nextAnswer.
	^peekBuffer.