As yet unclassified
tablesForANSIJoin
	"Which tables will we join. Assumes this is a single-level join"
	^self inject: Set new into: [:sum :each |
		each tableForANSIJoin isNil ifFalse: [sum add: each tableForANSIJoin].
		sum].