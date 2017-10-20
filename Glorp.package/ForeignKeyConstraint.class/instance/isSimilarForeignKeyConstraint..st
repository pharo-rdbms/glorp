testing
isSimilarForeignKeyConstraint: aConstraint

	self sourceFields size ~= aConstraint sourceFields size ifTrue: [^false].
	self sourceFields asSortedCollection with: aConstraint sourceFields asSortedCollection do: [:field1 :field2 | 
		(field1 matchesField: field2) ifFalse: [^false]].

	self targetFields size ~= aConstraint targetFields size ifTrue: [^false].
	self targetFields asSortedCollection with: aConstraint targetFields asSortedCollection do: [:field1 :field2 | 
		(field1 matchesField: field2) ifFalse: [^false]].
	^true