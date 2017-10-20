comparing
isTheSameAs: aDatabaseTable
	"Validate that two tables are exactly the same. Most useful for testing purposes, rather than normal usage, which is why we don't just use the #= method."
	self name asUppercase = aDatabaseTable name asUppercase ifFalse: [^false].
	"For the test purposes, we won't worry about schema right now."
"	self schema = aDatabaseTable schema ifFalse: [^false]."
	self fields size = aDatabaseTable fields size ifFalse: [^false].
	self fields asSortedCollection with: aDatabaseTable fields asSortedCollection do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].
	self foreignKeyConstraints size = aDatabaseTable foreignKeyConstraints size ifFalse: [^false].
	self foreignKeyConstraints with: aDatabaseTable foreignKeyConstraints do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].	
	self indexes with: aDatabaseTable indexes do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].
	self lockKeyFields with: aDatabaseTable lockKeyFields do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].	
	self primaryKeyFields size = aDatabaseTable primaryKeyFields size ifFalse: [^false].
	self primaryKeyFields asSortedCollection with: aDatabaseTable primaryKeyFields asSortedCollection do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].
	self isImaginary = aDatabaseTable isImaginary ifFalse: [^false].
	^true.
	"Note, we ignore parent and replacementSubselect"