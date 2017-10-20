accessing
session
	^self query isNil ifTrue: [nil] ifFalse: [self query session]