utility - inner queries
queryForCustomerStation
	| query |
	query := Query read: CustomerStation where:
		[:customerStation |
		customerStation successor anySatisfy:
			[:successor | successor id in: self queryForSuccessor]].
	query retrieve: [:customerStation | customerStation id].
	^query