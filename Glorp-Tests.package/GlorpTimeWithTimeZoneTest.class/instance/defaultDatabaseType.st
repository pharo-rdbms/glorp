types
defaultDatabaseType
	"For now, non-supporting platforms just repeat the superclass' tests.  Later, raise explicit test skip for non-supporting platforms."

	self platform isPostgreSQLPlatform ifTrue: [^self platform timetz].
	^super defaultDatabaseType