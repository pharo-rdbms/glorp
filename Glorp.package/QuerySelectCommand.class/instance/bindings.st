accessing
bindings
	self useBinding ifFalse: [^#()].
	boundExpressions isNil ifTrue: [self findBoundExpressions].
	^boundExpressions collect: [:each | each bindingIn: self].