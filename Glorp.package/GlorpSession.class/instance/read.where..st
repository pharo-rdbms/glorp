api/queries
read: aClass where: aBlock
	"aBlock should return a boolean, for example, [:each | each lastname = 'Doe']."

	^self execute: (SimpleQuery read: aClass where: aBlock)