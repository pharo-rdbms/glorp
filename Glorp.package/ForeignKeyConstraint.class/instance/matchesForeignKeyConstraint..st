testing
matchesForeignKeyConstraint: aConstraint
	name asUppercase = aConstraint name asUppercase ifFalse: [^false].
	self sourceFields size ~= aConstraint sourceFields size ifTrue: [^false].
	self sourceFields with: aConstraint sourceFields do: [:field1 :field2 | 
		(field1 matchesField: field2) ifFalse: [^false]].

	self targetFields size ~= aConstraint targetFields size ifTrue: [^false].
	self targetFields with: aConstraint targetFields do: [:field1 :field2 | 
		(field1 matchesField: field2) ifFalse: [^false]].
	^true