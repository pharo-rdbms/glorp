other
reserveSequenceNumbers: anInteger in: anAccessor for: aTable
	| numberNeeded firstNumber fakeRow |
	numberNeeded := anInteger - self availableReservedNumbers.
	numberNeeded <= 0 ifTrue: [^self].
	fakeRow := DatabaseRow newForTable: self field table.
	firstNumber := self
		getSequenceValueFromDatabaseFor: self field
		in: fakeRow
		using: anAccessor.
	self reservedNumbers addAll: (firstNumber to: firstNumber + numberNeeded - 1).