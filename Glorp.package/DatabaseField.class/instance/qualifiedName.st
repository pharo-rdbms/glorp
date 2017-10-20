querying
qualifiedName

	^table isNil 
		ifTrue: [self name]
		ifFalse: [self table qualifiedName, '.', self name].