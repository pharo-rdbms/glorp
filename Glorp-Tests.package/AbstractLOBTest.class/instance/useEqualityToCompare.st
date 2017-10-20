private
useEqualityToCompare
	^ self platform isSQLServerPlatform
		or: [ self platform isPostgreSQLPlatform ]