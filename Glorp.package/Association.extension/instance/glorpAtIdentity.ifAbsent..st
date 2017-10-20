*Glorp
glorpAtIdentity: aKey ifAbsent: aBlock
	"A cheat to let use use this like an identity dictionary"
	^key == aKey ifTrue: [value] ifFalse: aBlock.