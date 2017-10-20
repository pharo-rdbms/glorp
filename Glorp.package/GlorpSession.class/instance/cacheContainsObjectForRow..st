caching
cacheContainsObjectForRow: aDatabaseRow
	^self 
		cacheContainsObjectForClass: aDatabaseRow owner class
		key: aDatabaseRow primaryKey