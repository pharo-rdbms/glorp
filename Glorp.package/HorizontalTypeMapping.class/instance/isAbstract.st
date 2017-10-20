accessing
isAbstract
	^isAbstract isNil ifTrue: [ isAbstract := false ] ifFalse: [ isAbstract ]