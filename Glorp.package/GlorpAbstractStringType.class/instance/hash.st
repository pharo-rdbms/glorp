comparing
hash
	^self queryType == self
		ifTrue: [super hash bitXor: self width hash]
		ifFalse: [(super hash bitXor: self width hash) bitXor: self queryType hash]