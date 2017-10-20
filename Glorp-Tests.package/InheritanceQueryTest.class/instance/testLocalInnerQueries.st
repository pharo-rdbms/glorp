running
testLocalInnerQueries
	"The same as testInnerQueries, but with all the queries defined within the block (should run the same)."

	| query |
	query := Query read: CustomerStation where:
		[:customerStation |
		customerStation successor anySatisfy: 
			[:successor || query2 |
			query2 := Query read: Successor where: 
				[:successor1 || feederQuery |
				feederQuery := Query read: FeederStation where:
					[:feederStation | feederStation id in: #(1 2 3 4)].
				feederQuery retrieve: [:feederStation | feederStation id].
				successor1 successorFeeder id in: feederQuery].
			query2 retrieve: [:successor1 | successor1 id].
			successor id in: query2]].
	query retrieve: [:customerStation | customerStation id].
	session execute: query.