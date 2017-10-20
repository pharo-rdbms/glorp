accessing
bindingTypes
	^query isNil ifTrue: [#()] ifFalse: [super bindingTypes].