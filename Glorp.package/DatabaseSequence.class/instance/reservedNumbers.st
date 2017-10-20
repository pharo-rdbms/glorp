accessing
reservedNumbers
	reservedNumbers isNil ifTrue: [reservedNumbers := OrderedCollection new: 50].
	^reservedNumbers.