private/deletion
collapseMatchingInsertsAndDeletes
	^rowDictionary
		inject: Dialect identitySetClass new
		into:
			[:sum :eachTablesRowList | 
			sum addAll: (self collapseMatchingInsertsAndDeletesFor: eachTablesRowList).
			sum]