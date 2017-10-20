accessing
nonPrimaryKeyFields

	^self fields reject: [:each | each isPrimaryKey].