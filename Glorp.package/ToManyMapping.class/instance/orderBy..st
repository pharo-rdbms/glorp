api
orderBy: aBlockOrSelector
	orderBy isNil ifTrue: [orderBy := OrderedCollection new].
	orderBy add: aBlockOrSelector