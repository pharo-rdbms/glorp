converting
asNonDistinctField
	^self isDistinct ifTrue: [base] ifFalse: [self].