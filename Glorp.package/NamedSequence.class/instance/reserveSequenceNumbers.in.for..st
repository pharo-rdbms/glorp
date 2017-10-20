SQL
reserveSequenceNumbers: anInteger in: aSession for: aTable
	| numberNeeded numberToReserve |
	numberNeeded := anInteger - self availableReservedNumbers.
	numberNeeded <= 0 ifTrue: [^self].
	self
		reserveViaTableSelect: numberNeeded
		in: aSession
		for: aTable.
	[anInteger - self availableReservedNumbers >0 ] whileTrue: [
		numberToReserve := (anInteger - self availableReservedNumbers) min: (self maximumToReserveAtOnce).
		self reserveViaBackupMechanism: numberToReserve in: aSession].