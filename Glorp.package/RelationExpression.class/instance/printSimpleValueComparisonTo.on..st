printing SQL
printSimpleValueComparisonTo: value on: aStream
	value isNil
		ifTrue: [self printWithNullOn: aStream]
		ifFalse:
			[self printRelationOn: aStream.
			self printValue: value on: aStream].