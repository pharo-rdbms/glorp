accessing
nextSequenceNumber

	| id |
	id := nextId.
	nextId := nextId + 1.
	^id