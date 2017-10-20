fields
aliasedTableFor: aDatabaseTable 
	tableAliases isNil ifTrue: [^aDatabaseTable].
	aDatabaseTable isAliased ifTrue: [^aDatabaseTable].
	^tableAliases 
		at: aDatabaseTable 
		ifAbsent: [
			(self tables includes: aDatabaseTable) 	
				ifTrue: [self error: 'Bug. Expression has only partially aliased tables']
				ifFalse: [
					| tableExpression |
					tableExpression := self mappingExpressions at: aDatabaseTable ifAbsent: [nil].
					tableExpression isNil 
						ifTrue: [aDatabaseTable]
						ifFalse: [tableExpression aliasedTableFor: aDatabaseTable]]].