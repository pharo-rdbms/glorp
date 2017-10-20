counting
numberOfEntries
	self compress.
	^rowDictionary inject: 0 into: [:sum :each | sum + each size]