login
loginIfError: aBlock
	| result |
	result := self accessor loginIfError: aBlock.
	system platform characterEncoding: accessor encoding.
	^result