querying
quotedQualifiedName

	| basicName |
	basicName := self platform nameForColumn: self name.
	^table isNil 
		ifTrue: [basicName]
		ifFalse: [self table qualifiedName, '.', basicName].