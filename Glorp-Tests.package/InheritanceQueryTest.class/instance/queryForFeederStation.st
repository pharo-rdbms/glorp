utility - inner queries
queryForFeederStation
	| query |
	query := Query read: FeederStation where: [:feederStation | feederStation id in: #(1 2 3 4)].
	query retrieve: [:feederStation | feederStation id].
	^query