initialize-release
initialize
	super initialize.
	reusePreparedStatements := false.
	isInTransaction := false.
	logging := false "Set to true to see Glorp's SQL transcript."