ordering
groupBy: aBlock

	grouping isNil
		ifTrue: [grouping := Array with: aBlock]
		ifFalse: [grouping := grouping , (Array with: aBlock)].