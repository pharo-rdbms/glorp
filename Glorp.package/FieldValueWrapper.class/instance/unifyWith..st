unifying
unifyWith: targetWrapper
	(self containsWrapper: targetWrapper) ifTrue: [^self].
	(targetWrapper containsWrapper: self) ifTrue: [^self].
	targetWrapper hasValue ifFalse: [^targetWrapper replaceWith: self].
	self hasValue ifFalse: [^self replaceWith: targetWrapper].
	self contents = targetWrapper contents
		ifFalse: [self error: 'Conflicting values in rows'].
	targetWrapper replaceWith: self