api
mapFromSource: sourceObject andTarget: targetObject intoRowsIn: aRowMap
	(sourceObject isNil or: [targetObject isNil]) ifTrue: [^self].
	^(joins at: targetObject class)
		mapFromSource: sourceObject
		andTarget: targetObject
		intoRowsIn: aRowMap.