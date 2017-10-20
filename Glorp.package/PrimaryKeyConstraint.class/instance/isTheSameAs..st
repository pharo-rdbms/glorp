comparing
isTheSameAs: aPrimaryKeyConstraint
	"Validate that two constraints are exactly the same. Most useful for testing purposes, rather than normal usage, which is why we don't just use the #= method."
	self name asUppercase = aPrimaryKeyConstraint name asUppercase ifFalse: [^false].
	self primaryKeyFields size = aPrimaryKeyConstraint primaryKeyFields size ifFalse: [^false].
	self primaryKeyFields asSortedCollection with: aPrimaryKeyConstraint primaryKeyFields asSortedCollection do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].	
	self shouldCreateInDatabase = aPrimaryKeyConstraint shouldCreateInDatabase ifFalse: [^false].
	^true.