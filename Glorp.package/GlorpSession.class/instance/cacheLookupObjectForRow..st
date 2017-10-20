caching
cacheLookupObjectForRow: aDatabaseRow
	^self 
		cacheLookupForClass: aDatabaseRow owner class
		key: aDatabaseRow primaryKey