comparing
= aRowMapKey

	aRowMapKey class == self class ifFalse: [^false].
	^(key1 == aRowMapKey key1 and: [key2 == aRowMapKey key2]) or: [
		key2 == aRowMapKey key1 and: [key1 == aRowMapKey key2]]