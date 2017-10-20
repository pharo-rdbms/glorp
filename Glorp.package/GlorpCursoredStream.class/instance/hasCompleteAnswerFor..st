building objects
hasCompleteAnswerFor: objects
	| nextAnswer |
	self atEnd ifTrue: [^true].
	self mightHaveDuplicateRows ifFalse: [^true].
	nextAnswer := self peek.
	^objects ~= nextAnswer