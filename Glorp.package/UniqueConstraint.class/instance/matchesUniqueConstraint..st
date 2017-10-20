testing
matchesUniqueConstraint: aConstraint
	
	name asUppercase = aConstraint name asUppercase ifFalse: [^false].
	self fields size ~= aConstraint fields size ifTrue: [^false].
	self fields with: aConstraint fields do: [:each :other | (each matchesField: other) ifFalse: [^false]].
	^true