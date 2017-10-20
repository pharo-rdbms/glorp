accessing
getVisualAgeMessageText
	
	| tempTag |
	tempTag := self basicTag.
	^tempTag isNil ifTrue: [self printString] ifFalse: [tempTag errorText].