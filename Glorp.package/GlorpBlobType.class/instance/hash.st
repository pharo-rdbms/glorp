comparing
hash
	^self queryType == self
		ifTrue: [super hash]
		ifFalse: [super hash bitXor: self queryType hash]