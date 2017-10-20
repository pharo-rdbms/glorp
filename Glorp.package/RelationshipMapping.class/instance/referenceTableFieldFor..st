mapping
referenceTableFieldFor: aField
	^self usesLinkTable
		ifTrue: [nil]
		ifFalse: [self join targetForSource: aField].