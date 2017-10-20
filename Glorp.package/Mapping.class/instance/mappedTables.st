mapping
mappedTables
	^(self mappedFields collect: [:each | each table]) asSet