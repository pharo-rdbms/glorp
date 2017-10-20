api
add: anObject
	items add: anObject.
	items size > maximumSize ifTrue: [items removeFirst]