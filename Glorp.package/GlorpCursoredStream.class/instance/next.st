accessing
next
	| answer session |
	self atEnd ifTrue: [^nil].
	session := self session.

	[self atEnd ifTrue: [^nil].
	answer := self nextAnswer.
	answer == nil] 
		whileTrue.

	[self hasCompleteAnswerFor: answer] whileFalse: [self nextAnswer].
	session == nil ifFalse: [session privateRegisterAsOld: answer].
	^answer.