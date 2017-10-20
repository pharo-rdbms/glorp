bound values
singleRowBindings
	| bound |
	bound := OrderedCollection new.
	self singleRowBoundFields
		do:
			[:each | 
			| fieldValue |
			fieldValue := row at: each ifAbsent: [nil].
			(self canBind: fieldValue to: each type) ifTrue: [bound add: fieldValue]].
	^bound asArray.