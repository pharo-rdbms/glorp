lookup
at: key ifAbsentPut: aBlock 
	| item |
	item := self at: key ifAbsent: [nil].
	^item isNil 
		ifTrue: [ | newItem|
			newItem := policy cacheEntryFor: aBlock value.
			self markEntryAsCurrent: newItem.
			items at: key put: newItem]
		ifFalse: [self markEntryAsCurrent: item. item].