utility - inner queries
queryForSuccessor
	| query |
	query := Query read: Successor where:
		[:successor | successor successorFeeder id in: self queryForFeederStation].
	query retrieve: [:successor | successor id].
	^query