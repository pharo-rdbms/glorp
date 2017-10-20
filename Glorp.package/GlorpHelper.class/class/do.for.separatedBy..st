helpers
do: aBlock for: aCollection separatedBy: separatorBlock

	| array |
	array := aCollection asArray.
	1 to: array size do: [:i |
		| each |
		each := array at: i.
		aBlock value: each.
		i = array size ifFalse: [
			separatorBlock value]]