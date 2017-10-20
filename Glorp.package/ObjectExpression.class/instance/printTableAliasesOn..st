printing
printTableAliasesOn: aStream 
	self hasTableAliases 
		ifTrue: 
			[aStream nextPutAll: ' '.
			tableAliases keysAndValuesDo: [:eachKey :eachValue | 
				aStream nextPutAll: eachKey name, '->', eachValue name , ' ']]