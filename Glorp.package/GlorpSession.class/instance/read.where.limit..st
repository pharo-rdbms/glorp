api/queries
read: aClass where: aBlock limit: anInteger
	"Return an array of up to anInteger instances of aClass for which aBlock returns true, each from a row from its table."

	^self execute:
		(SimpleQuery
			read: aClass
			where: aBlock
			limit: anInteger)