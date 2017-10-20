api/queries
readOneOf: aClass where: aBlock
	"aBlock should return a boolean, for example, [:each | each title='Report']."

	^self execute: (SimpleQuery readOneOf: aClass where: aBlock)