as yet unclassified
queryForCustomerStation
	| query |
	query := Query read: CustomerStation
				where: [:customerStation | customerStation successor anySatisfy: [:successor | successor in: self queryForSuccessor]].
	query retrieve: [:customerStation | customerStation id].
	^query