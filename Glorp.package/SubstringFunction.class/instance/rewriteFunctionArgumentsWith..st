rewriting
rewriteFunctionArgumentsWith: mainArgument
	"This is pretty awful. We expect our main argument to be a string, and we're a substring function, but we know that for some types, the string representation comes out differently in the database. In particular, the Postgresql driver stores strings into lobs in Base64. So, if our previous argument = the string size, rewrite it to the database size. This makes it work if we do
    (someObject blob copyFrom: 1 to: 3) = 'abc'
when in fact, the length of that string in the blob will be 4."
	| platform |
	platform := base ultimateBaseExpression system platform.
	(platform class == PostgreSQLPlatform and: [self field type = platform blob]) ifTrue: [^self rewriteForPostgresqlBase64BlobsWith: mainArgument].
	(platform isOraclePlatform and: [self field type = platform blob]) ifTrue: [^self rewriteForOracleBlobsWith: mainArgument].
	"For MySQL and SQL Server, it wants position, length rather than startPosition, endPosition."
	(platform isMySQLPlatform or: [platform isSQLServerPlatform]) ifTrue: [arguments last value: (arguments last value - arguments first value + 1)].