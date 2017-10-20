as yet unclassified
queryForSuccessor
	| query |
	query := Query read: Successor where: [:successor | successor successorFeeder in: self queryForFeederStation].
	query retrieve: [:successor | successor id].
	^query