testing
matchesPrimaryKeyConstraint: aConstraint
	name = aConstraint name ifFalse: [^false].
	self primaryKeyFields size ~= aConstraint primaryKeyFields size ifTrue: [^false].
	self primaryKeyFields with: aConstraint primaryKeyFields do: [ :field1 :field2 | 
		(field1 matchesField: field2) ifFalse: [^false]].
	^true