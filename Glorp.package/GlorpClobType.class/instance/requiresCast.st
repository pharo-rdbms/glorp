testing
requiresCast
	^(self platform class = PostgreSQLPlatform) or: [self platform class = SQLServerPlatform]