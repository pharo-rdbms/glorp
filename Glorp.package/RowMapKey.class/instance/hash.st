comparing
hash
	| hash1 hash2 hash1Temp longHash |
	hash1 := key1 identityHash.
	hash2 := key2 identityHash.
	hash1 > hash2 ifTrue: [
		hash1Temp := hash1.
		hash1 := hash2.
		hash2 := hash1Temp].
	longHash := (hash1 bitShift: 8) bitXor: hash2.
	^Dialect fitHashIntoSmallInteger: longHash.