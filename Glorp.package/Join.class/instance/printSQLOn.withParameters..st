printing
printSQLOn: aStream withParameters: aDictionary 
	1 to: sources size
		do: 
			[:i | 
			| eachTarget eachSource sourceValue |
			eachTarget := targets at: i.
			eachSource := sources at: i.
			eachTarget printSQLOn: aStream withParameters: aDictionary.
			sourceValue := (self isConstant: eachSource) ifTrue: [eachSource value] ifFalse: [aDictionary at: eachSource].
			sourceValue isNil 
				ifTrue: [aStream nextPutAll: ' IS NULL ']
				ifFalse: 
					[aStream nextPutAll: ' = '.
					sourceValue printOn: aStream].
			i = targets size ifFalse: [aStream nextPutAll: ' AND ']]