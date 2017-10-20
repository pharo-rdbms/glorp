mapping
writeExtraInformationInto: aRowMap atKey: rowMapKey forSourceObject: sourceObject targetObject: targetObject atIndex: index
	shouldWriteTheOrderField
		ifTrue:
			[| keyForOrdering |
			keyForOrdering := self keyForOrderingFrom: sourceObject to: rowMapKey.
			aRowMap
				at: self orderField
				key: keyForOrdering
				put: index]