class lookup
lookedUpNames
	lookedUpNames isNil ifTrue: [lookedUpNames := IdentityDictionary new].
	^lookedUpNames.