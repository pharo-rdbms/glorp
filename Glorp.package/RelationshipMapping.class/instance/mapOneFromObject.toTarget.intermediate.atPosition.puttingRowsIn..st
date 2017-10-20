mapping
mapOneFromObject: sourceObject toTarget: targetObject intermediate: aRowMapKey atPosition: index puttingRowsIn: aRowMap
	self linkTableJoin
		mapFromSource: sourceObject
		andTarget: aRowMapKey
		intoRowsIn: aRowMap.
	self targetTableJoin isNil
		ifFalse:
			[self targetTableJoin
				mapFromSource: sourceObject
				andTarget: (self mapsSimpleObject ifTrue: [aRowMapKey] ifFalse: [targetObject])
				intoRowsIn: aRowMap].
	self usesLinkTable
		ifTrue:
			[self reverseJoin
				mapFromSource: aRowMapKey
				andTarget: (self mapsSimpleObject ifTrue: [aRowMapKey] ifFalse: [targetObject])
				intoRowsIn: aRowMap].
	self
		writeExtraInformationInto: aRowMap
		atKey: aRowMapKey
		forSourceObject: sourceObject
		targetObject: targetObject
		atIndex: index.