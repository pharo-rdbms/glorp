accessing
upToEnd
	| result |
	result := WriteStream on: (Array new: 100).
	[self atEnd] whileFalse: [
			| nextValue |
			"Stupid VA's cursors don't deal with atEnd or isEmpty nicely, so check for nil"
			nextValue := self next.
			nextValue == nil ifFalse: [	result nextPut: nextValue]].
	^result contents