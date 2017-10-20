as yet unclassified
allReservedWords

	| words |
	words := IdentityDictionary new.
	self allSubclasses do: [:each | words at: each put: each reservedWords].
	^words