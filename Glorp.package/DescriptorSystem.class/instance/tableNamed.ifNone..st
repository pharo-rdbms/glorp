api
tableNamed: aString ifNone: aBlock

	^tables at: aString asString asUppercase
		ifAbsent: 
			[| newTable |
			newTable := self databaseTableClass new.
			newTable name: aString.
			tables at: aString asUppercase put: newTable.
			self initializeTable: newTable.
			newTable isEmpty
				ifTrue: 
					[tables removeKey: aString asUppercase.
					^aBlock value].
			newTable]