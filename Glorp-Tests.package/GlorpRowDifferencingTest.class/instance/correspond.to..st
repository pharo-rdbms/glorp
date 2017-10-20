support
correspond: person1 to: person2 
	| correspondanceMap |
	correspondanceMap := IdentityDictionary new.
	correspondanceMap at: person1 put: person2.
	person1 address notNil ifTrue: 
		[correspondanceMap at: person1 address put: person2 address.
		"Now fix it up so this actually looks like a real memento"
		person2 address: person1 address].
	^correspondanceMap