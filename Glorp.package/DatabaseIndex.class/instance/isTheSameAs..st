comparing
isTheSameAs: aDatabaseIndex
	"Validate that two indexes are exactly the same. Most useful for testing purposes, rather than normal usage, which is why we don't just use the #= method."
	self name asUppercase = aDatabaseIndex name asUppercase ifFalse: [^false].
	self fields with: aDatabaseIndex fields  do: [:a :b | (a isTheSameAs: b) ifFalse: [^false]].	
	^true.