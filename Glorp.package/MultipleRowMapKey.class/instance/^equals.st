comparing
= aRowMapKey

	aRowMapKey class == self class ifFalse: [^false].
	aRowMapKey keys size = keys size ifFalse: [^false].
	"We can't rely on the order being the same because of the obscure but real case of two different related objects with the same identityHash"
	aRowMapKey keys do: [:each |
		(keys includes: each) ifFalse: [^false]].
	^true