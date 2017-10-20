comparing
isTheSameAs: aForeignKeyConstraint
	"Validate that two constraints are exactly the same. Most useful for testing purposes, rather than normal usage, which is why we don't just use the #= method."
	self name asUppercase = aForeignKeyConstraint name asUppercase ifFalse: [^false].
	self suffixExpression = aForeignKeyConstraint suffixExpression ifFalse: [^false].
	self sourceFields size ~= aForeignKeyConstraint sourceFields size ifTrue: [^false].
	self sourceFields asSortedCollection with: aForeignKeyConstraint sourceFields asSortedCollection do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].	
	self targetFields size ~= aForeignKeyConstraint targetFields size ifTrue: [^false].
	self targetFields asSortedCollection with: aForeignKeyConstraint targetFields asSortedCollection do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].	
	self shouldCreateInDatabase = aForeignKeyConstraint shouldCreateInDatabase ifFalse: [^false].
	^true.