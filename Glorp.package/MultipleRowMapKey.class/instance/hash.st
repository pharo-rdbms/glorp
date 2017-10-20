comparing
hash
	"Note: the two things with the same identity hash problem is OK here because if they do then the hashes are (by definition) the same, and the order doesn't matter"
	| increment hash |
	increment := 14 // keys size.
	hash := 0.
	keys doWithIndex: [:each :index |
		hash := hash bitXor: (each identityHash bitShift: increment * index)].
	^hash