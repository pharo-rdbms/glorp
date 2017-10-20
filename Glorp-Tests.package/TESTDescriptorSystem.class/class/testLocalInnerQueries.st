as yet unclassified
testLocalInnerQueries
	"self testLocalInnerQueries"

	| session system query result |
	session := GlorpSession new.
	system := self new.
	system platform: OraclePlatform new.
	session system: system.
	system session: session.
	query := Query read: CustomerStation where: 
		[:customerStation |
		customerStation successor anySatisfy: 
			[:successor || query2 |
			query2 := Query read: Successor where: 
				[:successor1 || feederQuery |
				feederQuery := Query read: FeederStation where:
					[:feederStation | feederStation id in: #(1 2 3 4)].
				feederQuery retrieve: [:feederStation | feederStation id].
				successor1 successorFeeder in: feederQuery].
			query2 retrieve: [:successor1 | successor1 id].
			successor in: query2]].
	query retrieve: [:customerStation | customerStation id].
	result := session execute: query.
	^result