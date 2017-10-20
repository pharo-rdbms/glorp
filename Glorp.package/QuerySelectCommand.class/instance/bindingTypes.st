accessing
bindingTypes
	self useBinding ifFalse: [^#()].
	boundExpressions isNil ifTrue: [self findBoundExpressions].
	^boundExpressions collect: [:each | each bindingType].