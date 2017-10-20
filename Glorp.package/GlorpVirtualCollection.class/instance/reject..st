enumerating
reject: aBlock
	^self copy AND: [:each | (aBlock value: each) not]